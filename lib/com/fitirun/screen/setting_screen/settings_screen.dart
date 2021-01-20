import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field_costum_icon.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserModel userModel = Warehouse().userModel;
  String name = Warehouse().userModel.name == null ? "" : Warehouse().userModel.name;
  String age =  Warehouse().userModel.age == null ? "0" : Warehouse().userModel.age;
  String height = Warehouse().userModel.height == null ? "160" : Warehouse().userModel.height;
  String weight = Warehouse().userModel.weight == null ? "50" : Warehouse().userModel.weight;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
        title: Align(
          alignment: Alignment.center,
            child: Text("Settings", style: TextStyle(fontSize: 20, color: Colors.black),)),
        leading: FlatButton(
          textColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
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
          }, icon: Icon(Icons.logout, color: Colors.black,), label: Text("Logout", style: TextStyle(fontSize: 20, color: Colors.black),))
        ],
    ),
    body: getBody(),
      persistentFooterButtons: [
        TextButton.icon(onPressed: (){
          userModel.name = name;
          userModel.age = age;
          userModel.weight = weight;
          userModel.height = height;
          DatabaseService().addOrUpdateUser(userModel);

          Navigator.pop(context);
        }, icon: Icon(Icons.save_alt_sharp, color: Colors.black,), label: Text("Save and continue", style: TextStyle(fontSize: 20, color: Colors.black),))
      ],
    );
  }

  Widget getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text("Name: ", style: TextStyle(fontSize: 20),)
            ),
            Align(
              alignment: Alignment.topRight,
              child: RoundedInputFieldCustomIcon(
                type: TextInputType.name,
                icon: Icons.drive_file_rename_outline,
                hintText: name == "" ? "Enter your name" : name,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                 },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text("Age: ", style: TextStyle(fontSize: 20),),
            ),
            RoundedInputFieldCustomIcon(
              type: TextInputType.number,
              icon: Icons.drive_file_rename_outline,
              hintText: age == ""? "Enter your age" : age,
              onChanged: (value) {
                setState(() {
                  age = value.toString();
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text("Height: ", style: TextStyle(fontSize: 20),),
            ),
            RoundedInputFieldCustomIcon(
              type: TextInputType.numberWithOptions(decimal: false),
              icon: Icons.drive_file_rename_outline,
              hintText: height == "" ? "Enter your height" : height,
              onChanged: (value) {
                setState(() {
                  height = value.toString();
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text("Weight: ", style: TextStyle(fontSize: 20),),
            ),
            RoundedInputFieldCustomIcon(
              type: TextInputType.numberWithOptions(decimal: false),
              icon: Icons.drive_file_rename_outline,
              hintText: weight == "" ? "Enter your weight" : weight,
              onChanged: (value) {
                setState(() {
                  weight = value.toString();
                });
              },
            )
          ],
        ),


      ],

    );
  }




  }
