
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/util/costum_widget/inputBox.dart';
import 'package:flutter/material.dart';

class CreateWorkoutScreen extends StatefulWidget {
  @override
  _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: homeScreen_purple_color,
          flexibleSpace: IconButton(
            icon: Icon(Icons.cancel_sharp, size: 25,),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          backgroundColor: Colors.white,
          title: SizedBox(
            child: Text("Create a workout", style: TextStyle(color: homeScreen_purple_color, fontSize: 26, fontWeight: FontWeight.bold),),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xff70e1f5),
        body: SingleChildScrollView(
          child: getBody(),
        ));
  }

  Widget getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InputBox(
          hintText: "Workout name",
        ),
        InputBox(
          hintText: "Number of Sets",
        )
      ],
    );
  }
}
