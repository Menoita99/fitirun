import 'dart:async';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunScreen extends StatefulWidget {
  @override
  _RunScreenState createState() => _RunScreenState();
}


class _RunScreenState extends State<RunScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

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
            child: Text("A mile a day\nKeeps the doctor away.", style: TextStyle(fontSize: 25, color: homeScreen_color, fontWeight: FontWeight.bold,),),),
        ),
        Container(
          height: height*0.695,
          child: getMap(),

        ),
      ],
    );
  }

  Widget getMap() {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      );
  }

}
