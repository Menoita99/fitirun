import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            Text("Name", style: TextStyle(fontSize: 20),),
            RoundedInputField(
              hintText: name == "" ? "type your name here" : name,
            )
          ],
        )

      ],

    );
  }
}
