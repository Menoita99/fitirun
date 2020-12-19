<<<<<<< HEAD
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
=======
import 'package:fitirun/com/fitirun/custom_widget/navigationBar.dart';
>>>>>>> 27ce3ce597049ebfbb0b89aa051f00038b8d5f04
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RunScreen extends StatefulWidget {
  @override
  _RunScreenState createState() => _RunScreenState();
}


class _RunScreenState extends State<RunScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
        ),
      ),
      body: getBody(),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }

  Widget getBody() {
    double width = MediaQuery.of(context).size.width;
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
        initialCameraPosition: CameraPosition(target: LatLng(37, 122), zoom: 12),
      ),
    );
  }


}
