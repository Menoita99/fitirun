import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/warehouse.dart';
import 'package:fitirun/com/fitirun/screen/run_screen/runManager.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:location/location.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'components/RadialProgress.dart';

class RunScreen extends StatefulWidget {
  @override
  _RunScreenState createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> with AutomaticKeepAliveClientMixin {

  RunManager manager = GetIt.I<RunManager>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Entrei no initState");
      initManagerListeners();
    });
  }


  void vibrate(int duration) async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: duration);
    }
  }


  void initManagerListeners() {
    UserModel userModel = Warehouse().userModel;
    manager.restart();
    manager.onTotalTick = ((tick){
      //if (!mounted)
        setState(() {
        });
    });


    manager.onExerciseTick = ((tick){
      //if (!mounted)
        if(tick <= 3 * 1000) vibrate(200);
    });

    manager.onExerciseDone = ((exerciseDone) {
      print("DONE $exerciseDone");
    });

    manager.onTotalDone = ((){
      //if (!mounted)
        if(manager.isWorkoutFinish()) {
          showFinishDialog();
          manager.saveStats(userModel);
          manager.restart();
      }else
        print("O workout não foi terminado");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }



  Widget getBody(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: blackText,
                tabs: [
                  Tab(
                      icon: Text(
                    "Map",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blackText,
                    ),
                  )),
                  Tab(
                    icon: Text(
                      "Manager",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackText,
                      ),
                    )),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapScreen(manager),
            ManagerScreen(manager),
          ],
        ),
      ),
    ));
  }

  Future<bool> showFinishDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!!!'),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Distance: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                      Text(manager.totalDistance.toString()+" m",style: TextStyle(fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('Congratulations you have completed your workout successfully!!!'),
                ],
              ),
            ),
          ),
          actions: [TextButton(child: Text('Nice!'),onPressed: () {manager.restart();Navigator.of(context).pop();})],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}



class MapScreen extends StatefulWidget {

  final RunManager manager;

  const MapScreen(this.manager);

  @override
  _MapScreenState createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen>  with AutomaticKeepAliveClientMixin {

  StreamSubscription _locationSubscription;
  Polyline _path = Polyline(polylineId: PolylineId("0"), color: dark_blue, width: 10,zIndex: 99);
  List<LatLng> pos = List();
  Location _location = Location();
  GoogleMapController _mapController;


  @override
  void initState(){
    super.initState();
    askForPermission();
    SchedulerBinding.instance.addPostFrameCallback((_) => initLocationListener());
  }


  @override
  void dispose() {
    if (_locationSubscription != null)
      _locationSubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0,0),
            zoom: 17,
          ),
          onMapCreated: (mapController) => setMapStyle(mapController,context),
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          trafficEnabled: true,
          polylines: Set.of((_path != null) ? [_path] : []),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.manager.isActive ?
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: timerBox(widget.manager.totalTimer.getFormattedCurrentTime(), 70),
              ),
            ):SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [timerContainer(), speedContainer()],
              ),
            )
          ],
        )
      ],
    );
  }




  Widget speedContainer() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(200),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.manager.speed.toString(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              " km/h",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }




  Widget timerBox(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          )
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }




  Widget timerContainer() {
    return widget.manager.isActive ? Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: pastel_green,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Center(
        child: Text(
          widget.manager.exerciseTimer.getFormattedCurrentTime(),
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ): SizedBox();
  }





  void setMapStyle(GoogleMapController mapController, BuildContext context) async{
    _mapController = mapController;
    String style =  await DefaultAssetBundle.of(context).loadString('assets/mapStyle/style.json');
    _mapController.setMapStyle(style);
  }






  void initLocationListener() async {
    try {
      if (_locationSubscription != null)
        _locationSubscription.cancel();
      _location.changeSettings(interval: 1000,distanceFilter: 0);
      _locationSubscription = _location.onLocationChanged.listen((position) {
        LatLng loc = LatLng(position.latitude, position.longitude);
        if (_mapController != null) {
          _mapController.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                tilt: 10,
                bearing: position.heading,
                target: loc,
                zoom: 17,)));
          if (widget.manager.isActive) {
            widget.manager.updateStats(position);
            setState(() {
              List<LatLng> points = List();
              _path.points.forEach((e) => points.add(e));
              if (!points.contains(loc))
                points.add(loc);
              //speed = loc.longitude == _position.longitude && loc.latitude == _position.latitude ? 0 : (position.speed * 3.6 ).toInt();
              widget.manager.speed = (position.speed * 3.6).toInt(); //remove 10% for error
              _path = Polyline(polylineId: PolylineId("0"),
                  color: _path.color,
                  width: _path.width,
                  points: points,
                  zIndex: _path.zIndex);
            });
          }else if(_path.points.isNotEmpty){
            _path = Polyline(polylineId: PolylineId("0"),
                color: _path.color,
                width: _path.width,
                points: [],
                zIndex: _path.zIndex);
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
        _showPermissionDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
      }
    }
  }



  void askForPermission() async {
    if (! await  Permission.activityRecognition.request().isGranted)
      return _showPermissionDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
    if(await _location.serviceEnabled())
      return;
    if(!await _location.requestService())
      return _showPermissionDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
  }




  Future<void> _showPermissionDialog(String title, String description,String solution) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
                Text(solution),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text('Ok'),
                onPressed: () => {
                  LocationPermissions().openAppSettings(),
                  Navigator.of(context).popAndPushNamed("/home"),
                }
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}



class ManagerScreen extends StatefulWidget {

  final RunManager manager;

  const ManagerScreen(this.manager);

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}


class _ManagerScreenState extends State<ManagerScreen> with AutomaticKeepAliveClientMixin{
  PageController _controller = PageController(initialPage: 0);
  List<RunModel> _availableWorkouts = List();
  FlutterTts tts = FlutterTts();

  @override
  void initState(){
    super.initState();
    /*for(int i = 0; i<6;i++){
      print("Aqui");
      DatabaseService().addRun(RunModel.fakeModel());
    }*/
      //_availableWorkouts.add(RunModel.fakeModel());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  widget.manager.hasModel() ? getTrainExercisesContainer(context) : SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Choose your workout',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          ),
          RaisedButton(
              child: Text('Speak mother fucker'),
              onPressed: () => speak()),
          buildRuns(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildRuns(){
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().runs,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        List<RunModel> runs = List();
        for(int i = 0; i<snapshot.data.docs.length; i++){
          RunModel run = RunModel.fromDoc(snapshot.data.docs[i]);
          runs.add(run);
        }

        return runs.isNotEmpty ? Container(
          height: size.height,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: runs.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: _makeContainer(runs[index]),
            ),
          ),
        ) : Center(child: Text("No runs available"),);
      },

    );
  }

   Widget _makeContainer(RunModel e){
     Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.manager.model = e;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top:10),
        child: Container(
          width: size.width*0.9,
          height:  e.title.length*5 < size.width*0.8 ? 130 : 155,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5),
              Container(
                  width: 5,
                  height:  e.title.length*5 < size.width*0.8 ? 100 : 130,
                  decoration: BoxDecoration(
                      color: getDifficultyColor(e.difficulty),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:size.width*0.8,
                      height: e.title.length*5 < size.width*0.8 ? 25 : 50,
                      child: Text(e.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesome5.clock,size: 16,color: Colors.grey[500],),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(' '+e.getFormatedDuration(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey[500]),),
                          )
                        ]),
                    SizedBox(height: 5),
                    Container(
                        width:size.width*0.8,
                        height: 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(e.shortDescription,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14),)),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getTrainExercisesContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height:  0.36 * size.height,
          child: PageView(
            physics: ScrollPhysics(),
          controller: _controller,
            children: [getTimerScreen(size),
              getChartScreen(size,Color(0xFF88a9bc),Colors.grey[200],widget.manager.getDistanceData(),'Distance'),
              getChartScreen(size,Color(0xFFd9bcb8),Colors.grey[200],widget.manager.getSpeedData(),'Speed'),
              getChartScreen(size,Colors.grey[400],Colors.grey[200],widget.manager.getCaloriesData(),'Calories'),
            ],
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.52,
            minChildSize: 0.52,
            maxChildSize: 1,
            builder: (context, controller) {
              return SingleChildScrollView(
                controller: controller,
                child: Container(
                  height: size.height * 0.815,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: blackText.withOpacity(0.2),width: 0.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Column(
                            children: widget.manager.model.exercises
                                .map((e) => getTrainItem(context, e, false))
                                .toList()),
                        widget.manager.isActive ?
                        RoundButton(
                          title: "Stop workout",
                          color: pastel_red,
                          textColor: Colors.white,
                          height: 50,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                            onPress: (() => showComfirmFinishWorkoutDialog().then((value) {
                              print(value);
                              if (value)
                                setState(()=>widget.manager.restart());
                            }))
                        )
                            :
                        Column(
                          children: [
                            RoundButton(
                              title: "Start workout",
                              color: Color(0xff9edbde),
                              textColor: Colors.white,
                              height: 50,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              onPress: () => showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) => AlertDialog(content: CountdownText()) ,
                              ).then((value) => setState(() => widget.manager.start())),
                            ),
                            RoundButton(
                                title: "Close workout",
                                color: Color(0xffe76361),
                                textColor: Colors.white,
                                height: 50,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                onPress: () => setState(() => widget.manager.restart()),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget getTimerScreen(Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
        height: 0.35 * size.height,
        decoration: BoxDecoration(
          color: Color(0xFF9edbde),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: RadialProgress(
                        width: size.width * 0.36,
                        height: size.width * 0.36,
                        progress: widget.manager.isActive ? widget.manager.completePercentage() : 0.001,
                        color: Colors.white,
                        subtext: "time left",
                        text: widget.manager.isActive ? widget.manager.timeLeft() : widget.manager.model.getFormatedDuration(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_football,color: Colors.white),
                    SizedBox(width: 10),
                    Text(widget.manager.totalSteps.toString()+ " steps",style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_sharp,color: Colors.white,),
                    SizedBox(width: 10),
                    Text(widget.manager.totalDistance.toString()+ " meters",style: TextStyle(color: Colors.white))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_outlined,color: Colors.white),
                    SizedBox(width: 10),
                    Text(widget.manager.totalCalories.toInt().toString()+" kca",style: TextStyle(color: Colors.white))
                  ],
                ),
              ],
            ),
    );
  }

  Widget getTrainItem(BuildContext context, ExerciseRunModel exercise, bool bool) {
    Size size = MediaQuery.of(context).size;
    RunManager manager = widget.manager;
    int index = manager.getExerciseIndex(exercise);
    return GestureDetector(
      onTap: () => exerciseDescription(exercise),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
        child: Container(
          height: 50,
          width: size.width - 10,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: index < manager.exerciseIndex ? pastel_green.withOpacity(0.5) :
            index == manager.exerciseIndex && manager.isActive ? pastel_blue.withOpacity(0.5) : Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: blackText.withOpacity(0.2),width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: blackText.withOpacity(0.2),width: 0.5),
                    color:index < manager.exerciseIndex ? Colors.grey[300] :
                    index == manager.exerciseIndex && manager.isActive ?  Colors.grey[100] : Colors.white,
                    shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    index < manager.exerciseIndex ? 0.toString() :
                      index == manager.exerciseIndex ? (manager.exerciseTimer == null ? exercise.duration.toString() : (manager.exerciseTimer.currentTick~/1000).toInt().toString())
                        : exercise.duration.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exercise.title,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      exercise.getFormatedDuration(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exerciseDescription(ExerciseRunModel exercise) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.title),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Duration: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                      Text(exercise.getFormatedDuration(),style: TextStyle(fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(exercise.description),
                ],
              ),
            ),
          ),
          actions: [TextButton(child: Text('Nice!'),onPressed: () => Navigator.of(context).pop())],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getChartScreen(Size size,Color mainColor, Color lineColor,List<double> data,String title) {
    return Container(
      height: 0.35 * size.height,
      margin: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          )
        ],
      ),
      child: Column(
        children: [
          Text(title,style: TextStyle(color: Colors.white,fontSize: 20),),
          Expanded(
            child: Sparkline(
              data: data.isNotEmpty ? data : [0],
              fillMode: FillMode.none,
              lineColor: lineColor,
              pointsMode: PointsMode.none,
              pointColor: homeScreen_purple_color,
              lineWidth: 10,
            ),
          ),
        ],
      ));
  }

  Future<bool>showComfirmFinishWorkoutDialog() {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Are you sure you want to give up?\nWe will save this workout data'),
          actions: [
            TextButton(child: Text('Yes'),onPressed: () {
              widget.manager.saveStats(userModel);
              Navigator.of(context).pop(true); }),
            TextButton(child: Text('No'),onPressed: () => Navigator.of(context).pop(false))],
        );
      },
    );
  }

  void speak() async {
    await tts.speak("Speak mother fucker");
  }
}





class CountdownText extends StatefulWidget {

  @override
  _CountdownTextState createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  int count = 3;
  Timer t;

  @override
  Widget build(BuildContext context) {
    if(t == null) {
      t = Timer.periodic(Duration(seconds: 1), (timer) async{
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 200);
        }
        this.setState(() {
          count--;
          if (count <= 0) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            t.cancel();
          }
        });
      });
    }
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: pastel_green,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(count.toString(), style: TextStyle(color: Colors.white,fontSize: 55,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String title;
  final Color color,textColor;
  final double height, width,fontSize;
  final FontWeight fontWeight;
  final Function onPress;

  const RoundButton({ Key key, this.title, this.color, this.fontWeight ,this.width,this.height = 50,this.fontSize = 18,this.textColor,this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Container(
          height: height,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(child: Text(title,style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: textColor
          ),)),
        ),
      ),
    );
  }
}
