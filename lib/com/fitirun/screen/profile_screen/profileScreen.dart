import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PageController _controller = PageController(initialPage: 0);

  DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: blackText),
          onPressed: () async {
            setState(() {
              TrainModel tmodel = TrainModel.fakeModel();
              _databaseService.addTrain(tmodel);
            });
          },
        ),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: 0.34 * size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Column(
                children: [
                  Align( alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("My profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),),
                  ),
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Column(
                      children: [

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: size.width * 0.115, //change
                          backgroundColor: Colors.brown.shade800,
                          child: Text('RM'),
                        ),
                      ),
                    ],),
                    Column(
                      children: [
                      Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text("Rui Menoita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          children: [
                            Text("15000"),
                            Text("Steps")
                          ],
                        ),
                      ),
                    ],)
                  ],),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.60,
              minChildSize: 0.60,
              maxChildSize: 1,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          width: 75,
                          margin: EdgeInsets.only(bottom: 10,top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: pastel_dark_grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          tabButton('Statistics',0),
                          tabButton('Food',1),
                          tabButton('Workout',2),
                        ],),
                        Container(
                          height: size.height,
                          child: PageView(
                            controller: _controller,
                            children: [
                              StatisticsView(),
                              FavFoodView(),
                              getView(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  Widget tabButton(String title,int i) {
    return GestureDetector(
        onTap: (() {
          _controller.animateToPage(i,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut);
        }),
      child: Container(
        margin: EdgeInsets.only(top: 10,bottom: 10),
        padding: EdgeInsets.only(bottom: 5,top: 5,left: 10,right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: blackText, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text('$title', style: TextStyle(fontSize: 20),),
      ),
    );
  }

  Widget getView() {
    return Container(
      height: 600,
      color:Colors.blue,
      child: Text(''),
    );
  }
}


class FavFoodView extends StatefulWidget {
  @override
  _FavFoodViewState createState() => _FavFoodViewState();
}

class _FavFoodViewState extends State<FavFoodView> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}





class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {//with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 0.3 * size.height,
          width: 0.9 * size.width,
          decoration: BoxDecoration(
            color: dark_blue,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: size.height*0.12,
                  width: size.width*0.23,
                  decoration: BoxDecoration(
                    color: suave_pink,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(130)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: size.height*0.12,
                  width: size.width*0.12,
                  decoration: BoxDecoration(
                    color: pastel_brown_orange,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(130),bottomRight: Radius.circular(130)),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

}
