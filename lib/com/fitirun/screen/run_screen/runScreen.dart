import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(37, 122), zoom: 12),
    );
  }
}

