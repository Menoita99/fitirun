import 'dart:async';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/util/Location/locationUtils.dart';
import 'package:fitirun/com/fitirun/util/Location/user_location.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunScreen extends StatefulWidget {
  LocationUtils locationUtils = new LocationUtils();
  Future<UserLocation> currentLocation;
  LatLng _center = LatLng(150, 100);

  RunScreen() {
    this.currentLocation = locationUtils.getLocation();
    currentLocation.then((locationData) => {
          if (locationData != null)
            {_center = LatLng(locationData.latitude, locationData.longitude)}
        });
  }
  @override
  _RunScreenState createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {


  GoogleMapController _controller;

  static final CameraPosition initialLocation =
      CameraPosition(target: LatLng(37, -122), zoom: 14);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: getBody(),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }

  Widget getBody() {
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "A mile a day\nKeeps the doctor away.",
              style: TextStyle(
                fontSize: 25,
                color: homeScreen_color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: height * 0.695,
          child: getMap(),
        ),
      ],
    );
  }

  Widget getMap() {
    print("long:" +
        widget._center.longitude.toString() +
        "lat" +
        widget._center.latitude.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: initialLocation,
      ),
    );
  }
}
