import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field_costum_icon.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = Warehouse().userModel.name == null ? "" : Warehouse().userModel.name;
  String nameAux = "";
  int age =  Warehouse().userModel.age == null ? 0 : Warehouse().userModel.age;
  int ageAux = 0;
  int weight = 0;
  int auxWeight = 0;
  int height = 0;
  int auxHeight = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black12,
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
      persistentFooterButtons: [
        TextButton.icon(onPressed: (){
          print(ageAux);
          print(nameAux);
          print(auxHeight);
          print(auxWeight);

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
          children: [
            Text("Name: ", style: TextStyle(fontSize: 20),),
            RoundedInputFieldCustomIcon(
              type: TextInputType.name,
              icon: Icons.drive_file_rename_outline,
              hintText: name == "" ? "Enter your name" : name,
              onChanged: (value) {
                setState(() {
                  nameAux = value;
                });
               },
            )
          ],
        ),
        Row(
          children: [
            Text("Age: ", style: TextStyle(fontSize: 20),),
            RoundedInputFieldCustomIcon(
              type: TextInputType.number,
              icon: Icons.drive_file_rename_outline,
              hintText: age == 0 ? "Enter your age" : age.toString(),
              onChanged: (value) {
                setState(() {
                  ageAux = int.parse(value);
                });
              },
            )
          ],
        ),
        Row(
          children: [
            Text("Height: ", style: TextStyle(fontSize: 20),),
            RoundedInputFieldCustomIcon(
              type: TextInputType.numberWithOptions(decimal: false),
              icon: Icons.drive_file_rename_outline,
              hintText: height == 0 ? "Enter your height" : height,
              onChanged: (value) {
                setState(() {
                  auxHeight = int.parse(value);
                });
              },
            )
          ],
        ),
        Row(
          children: [
            Text("Weight: ", style: TextStyle(fontSize: 20),),
            RoundedInputFieldCustomIcon(
              type: TextInputType.numberWithOptions(decimal: false),
              icon: Icons.drive_file_rename_outline,
              hintText: weight == 0 ? "Enter your weight" : weight,
              onChanged: (value) {
                setState(() {
                  auxWeight = int.parse(value);
                });
              },
            )
          ],
        ),
      ],
    );
  }
  }
