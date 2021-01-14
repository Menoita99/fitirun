import 'package:fitirun/com/fitirun/custom_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: blackText),
          onPressed: () => print("something"),
        ),
      ),
      body: SingleChildScrollView(child: getBody()),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_pin, size: 150,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Francisco Cardoso, 22", style: TextStyle(
                color: homeScreen_purple_color,
                fontWeight: FontWeight.bold,
                fontSize: 20),),
          ],
        ),
        IconButton(
          icon: Icon(Icons.my_library_add_rounded, size: 50,),
          onPressed:() => createWorkout(),
        )
      ],

    );
  }

  createWorkout(){
    Navigator.popAndPushNamed(context, '/createWorkout');
  }



}