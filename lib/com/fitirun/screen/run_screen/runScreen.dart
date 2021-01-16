import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Location _location = Location();
  Position _position = Position(latitude: 38,longitude: -9);
  GoogleMapController _mapController;
  List<LatLng> pos = List();


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

  setMapStyle(GoogleMapController mapController, BuildContext context) async{
    _mapController = mapController;
    String style =  await DefaultAssetBundle.of(context).loadString('assets/mapStyle/style.json');
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: timerBox("10:23", 70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [getManagerTimer(), getSpeed()],
              ),
            )
          ],
        )
      ],
    );
  }


  void getCurrentLocation() async {
    try {
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _location.onLocationChanged.listen((newLocalData) {
        LatLng loc = LatLng(newLocalData.latitude, newLocalData.longitude);
        print(newLocalData);
        if (_mapController != null) {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.8334901395799,
              target: loc,
              tilt: 0,)));
          setState(() {
            List<LatLng> points = List();
            _path.points.forEach((e) => points.add(e));
            if(!points.contains(loc))
              points.add(loc);
            _path = Polyline(polylineId: PolylineId("0"), color: _path.color, width: _path.width,points: points,zIndex: _path.zIndex);
          });
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
        _showMyDialog('Can\'t access to your location','Location services are disabled.','Please enable location use for this app');
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    askForPermission();
    getCurrentLocation();
    getCurrentLocation();
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
                Navigator.of(context).pushNamed("/home"),
              }
            ),
          ],
        );
      },
    );
  }

  Widget getSpeed() {
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
              "12",
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

  Widget getManagerTimer() {
    return Container(
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
          "00:20",
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget managerView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TrainModel train = TrainModel.fakeModel();
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
                          children: train.train
                              .map((e) => getTrainItem(context, e, false))
                              .toList()),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget getTrainItem(BuildContext context, ExerciceModel exercise, bool bool) {
    Size size = MediaQuery.of(context).size;
    return Padding(
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
                    exercise.bodyPart,
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
    );
  }


}
