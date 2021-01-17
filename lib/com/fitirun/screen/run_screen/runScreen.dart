import 'dart:async';
import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/util/Timer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:location/location.dart';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'components/RadialProgress.dart';

class RunScreen extends StatefulWidget {
  @override
  _RunScreenState createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {

  StreamSubscription _locationSubscription;
  Polyline _path = Polyline(polylineId: PolylineId("0"), color: dark_blue, width: 10,zIndex: 99);
  List<LatLng> pos = List();
  Location _location = Location();
  LatLng _position = LatLng(38,-9);
  GoogleMapController _mapController;
  int speed = 0;
  CustomTimer _totalTimer;
  CustomTimer _exerciseTimer;
  RunModel model = RunModel.fakeModel();



  @override
  void initState(){
    initLocationListener();
    super.initState();
    askForPermission();
   // _exerciseTimer = CustomTimer(startAt: 60*1000,stopAt: 0,onTick: () => this.setState(() =>{}));
   // _totalTimer = CustomTimer(startAt: 0,onTick: () => this.setState(() =>{}));
  }



  @override
  void dispose() {
    if (_locationSubscription != null)
      _locationSubscription.cancel();

    if(_exerciseTimer != null)
      _exerciseTimer.stop();

    if(_totalTimer != null)
      _totalTimer.stop();

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
      bottomNavigationBar: NavigationBottomBar(),
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
            mapView(context),
            managerView(context),
          ],
        ),
      ),
    ));
  }




  void setMapStyle(GoogleMapController mapController, BuildContext context) async{
    _mapController = mapController;
    String style =  await DefaultAssetBundle.of(context).loadString('assets/mapStyle/style.json');
    print(style);
    _mapController.setMapStyle(style);
  }




  Widget mapView(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_position.latitude, _position.longitude),
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
            _totalTimer != null ?
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: timerBox(_totalTimer.getFormattedCurrentTime(), 70),
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




  void initLocationListener() async {
    try {
      if (_locationSubscription != null)
        _locationSubscription.cancel();
      _location.changeSettings(interval: 100,distanceFilter: 10);
      _locationSubscription = _location.onLocationChanged.listen((position) {
        LatLng loc = LatLng(position.latitude, position.longitude);
        print('---------------------------------------------------------------');
        print(position);
        print(position.speed);
        print('---------------------------------------------------------------');
        if (_mapController != null) {
          _mapController.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                tilt: 10,
                bearing: position.heading,
                target: loc,
                zoom: 17,)));
          if (model != null) {
            setState(() {
              List<LatLng> points = List();
              _path.points.forEach((e) => points.add(e));
              if (!points.contains(loc))
                points.add(loc);
              //speed = loc.longitude == _position.longitude && loc.latitude == _position.latitude ? 0 : (position.speed * 3.6 ).toInt();
              speed = (position.speed * 3.6).toInt(); //remove 10% for error
              _path = Polyline(polylineId: PolylineId("0"),
                  color: _path.color,
                  width: _path.width,
                  points: points,
                  zIndex: _path.zIndex);
              _position = loc;
            });
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
        _showMyDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
      }
    }
  }




  void askForPermission() async {
    if(await _location.serviceEnabled())
      return;
    if(!await _location.requestService())
      return _showMyDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
  }




  Future<void> _showMyDialog(String title, String description,String solution) async {
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
              speed.toString(),
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
    return _exerciseTimer != null ? Container(
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
          _exerciseTimer.getFormattedCurrentTime(),
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ): SizedBox();
  }




   Widget managerView(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RadialProgress(
                    width: size.width * 0.36,
                    height: size.width * 0.36,
                    progress: 0.6,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_football),
                    SizedBox(width: 10),
                    Text("3265 steps")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_outlined),
                    SizedBox(width: 10),
                    Text("862 kca")
                  ],
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.55,
              maxChildSize: 1,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    height: size.height * 0.805,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Column(
                              children: model.exercises
                                  .map((e) => getTrainItem(context, e, false))
                                  .toList()),
                          GestureDetector(
                            onTap: () => print("Workout starting"),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                              child: Container(
                                height: 50,
                                width: size.width-10,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: pastel_blue,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Center(child: Text("Start Workout",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white
                                ),)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }




  Widget getTrainItem(BuildContext context, ExerciseRunModel exercise, bool bool) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => exerciseDescription(exercise),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
        child: Container(
          height: 50,
          width: size.width - 10,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              )
            ],
          ),
          child: Row(
            children: [
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
                      Text('Duration: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
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
  
/*
  Future<RunModel> selectTrainDialog() async{
    List<RunModel> availableTrains = List();
    for(int i = 0; i<6;i++)
      availableTrains.add(RunModel.fakeModel());
    return showDialog<RunModel>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a train'),
          content: SingleChildScrollView(
            child: Column(
              children: availableTrains.map((e) =>
                GestureDetector(
                  onTap: ()=>(Navigator.pop(context,e)),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(e.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Icon(FontAwesome5.clock),
                          Text(e.getFormatedDuration()),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text(e.shortDescription),
                    ],
                  ),
                )).toList(),
            ),
          ),
          actions: [TextButton(child: Text('Never mind'),onPressed:() {
            Navigator.pop(context,"PUTA DA TUA TIA");
        },)],
        );
      },
    ).then((value) => null);
  }
}
*/