import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/profile_screen/profileScreen.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field_costumicon.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = Warehouse().userModel.name;
  String age =  Warehouse().userModel.age.toString();



  @override
  Widget build(BuildContext context) {
    print(name);
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text("Settings"),
        leading: FlatButton(
          textColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          FlatButton.icon(onPressed: () {
            AuthService().signOut().then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WelcomeScreen()),
                      (route) => false);
            });
          }, icon: Icon(Icons.logout, color: Colors.blueAccent,), label: Text("Logout"))
        ],
    ),
    body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text("Name: ", style: TextStyle(fontSize: 20),),
            RoundedInputFieldCostumIcon(
              icon: Icons.drive_file_rename_outline,
              hintText: name == null ? "Enter your name" : name,
            )
          ],
        )

      ],

    );
  }
}
