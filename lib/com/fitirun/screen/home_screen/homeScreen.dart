import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int loginStreak = 15;
  int currentWeight = 65;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("Be your best version", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25, fontStyle: FontStyle.italic), ),
      ),
      body: getBody(),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }


  Widget getBody(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
          child: Row(
            children: [
              Text.rich(
                  TextSpan( style: TextStyle(backgroundColor: Colors.grey),
                    text: '', children: <TextSpan>[
                      TextSpan(text: "Login ", style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(text: "Streak: ", style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(text: "$loginStreak", style: TextStyle(fontWeight: FontWeight.bold))
                  ]
              )),
              Text.rich(
                  TextSpan(
                      text: '', children: <TextSpan>[
                    TextSpan(text: "Current ", style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: "Weight: ", style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: "$currentWeight", style: TextStyle(fontWeight: FontWeight.bold))
                  ]
                  )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )
      ],

    );
  }
}
