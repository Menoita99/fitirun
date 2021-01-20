import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/model/warehouse.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsHealthScreen.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsTrainScreen.dart';
import 'package:fitirun/com/fitirun/screen/profile_screen/components/BarChart.dart';
import 'package:fitirun/com/fitirun/screen/setting_screen/settings_screen.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';


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
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserModel user = Warehouse().userModel;
    return Stack(
      children: [
        SafeArea(
          child: Container(
            height:size.height,
            color:Color(0xffdddddd),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("My Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: blackText),
                        onPressed: () {
                            Navigator.push( context, MaterialPageRoute( builder: (context) => SettingsScreen())).then((value) => setState(() {}));
                        },
                      ),
                    ],

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: ((){
                              Navigator.push( context, MaterialPageRoute( builder: (context) => SettingsScreen())).then((value) => setState(() {}));
                              /*
                              for(int i = 0; i < 50; i++) {
                                DatabaseService().addFood(FoodModel.fakeFood());
                                DatabaseService().addTrain(TrainModel.fakeModel());
                              }
                              print('Done');*/
                            }),
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: pastel_brown
                              ) ,
                              child: Icon(FontAwesome5.user,color: white,size: 90,),

                            ),
                          ),
                        ],),
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Text(user.name == null ? 'User' : user.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
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
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.60,
            maxChildSize: 1,
            builder: (context, controller) {
              return SafeArea(
                child: GestureDetector(
                  onTap: ((){
                    controller.position.moveTo(0,duration: Duration(seconds: 1));
                  }),
                  child: Container(
                    color: white,
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
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
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
                                        FavWorkoutView(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )
      ],
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





class FavWorkoutView extends StatefulWidget {
  @override
  _FavWorkoutViewState createState() => _FavWorkoutViewState();
}

class _FavWorkoutViewState extends State<FavWorkoutView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserModel user = Warehouse().userModel;
    return user.favWorkouts.isNotEmpty ? ListView.builder(
      itemCount: user.favWorkouts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => (Navigator.push( context, MaterialPageRoute( builder: (context) => DetailsTrainScreen(item: user.favWorkouts[index],))).then((value) {
            setState(() {});
          })),
          child: Container(
            margin: EdgeInsets.only(top:25,left: 15,right: 15),
            height:230,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow:[BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              )],
            ),
            child: Column(
                children: [ ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: new CachedNetworkImage(
                    imageUrl: user.favWorkouts[index].image,
                    height: 120,
                    width:  1 * size.width,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(top:8,left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(user.favWorkouts[index].title,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.access_time,size: 16,color: blackText,),
                        SizedBox(width: 2),
                        Text(user.favWorkouts[index].time.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: blackText),),
                        SizedBox(width: 10),
                        Text(user.favWorkouts[index].difficulty.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: blackText),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8,left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(user.favWorkouts[index].description.toString().length > 80 ? user.favWorkouts[index].description.toString().substring(0,80).replaceAll("\n", "")+"..." :
                      user.favWorkouts[index].description.toString().replaceAll("\n", "")
                        ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: blackText),),
                    ),
                  ),

                ]
            ),
          ),
        );
      },
    ) : Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text('You don\'t have any favorites :(',style: TextStyle(fontSize: 20))
      ),
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
   Size size = MediaQuery.of(context).size;
   UserModel user = Warehouse().userModel;
   return user.favFoods.isNotEmpty ?ListView.builder(
     itemCount: user.favFoods.length,
     itemBuilder: (context, index) {
       return GestureDetector(
         onTap: () => (
             Navigator.push( context, MaterialPageRoute( builder: (context) => DetailsHealthScreen(item: user.favFoods[index],))).then((value) {
              setState(() {});
             })
         ),
         child: Container(
           margin: EdgeInsets.only(top:25,left: 15,right: 15),
           height:230,
           decoration: BoxDecoration(
             color: white,
             borderRadius: BorderRadius.all(Radius.circular(10)),
             boxShadow:[BoxShadow(
               color: Colors.grey.withOpacity(0.5),
               spreadRadius: 3,
               blurRadius: 5,
               offset: Offset(0, 2), // changes position of shadow
             )],
           ),
           child: Column(
               children: [ ClipRRect(
                 borderRadius: BorderRadius.all(Radius.circular(10)),
                 child: new CachedNetworkImage(
                   imageUrl: user.favFoods[index].image,
                   height: 120,
                   width:  1 * size.width,
                   fit: BoxFit.cover,
                   placeholder: (context, url) => CircularProgressIndicator(),
                 ),
               ),
                 Padding(
                   padding: const EdgeInsets.only(top:8,left: 8),
                   child: Align(
                     alignment: Alignment.centerLeft,
                     child: Text(user.favFoods[index].title,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 8),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Icon(Icons.access_time,size: 16,color: blackText,),
                       SizedBox(width: 2),
                       Text(user.favFoods[index].preparationTime.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: blackText),),
                       SizedBox(width: 10),
                       Icon(Icons.people,size: 16,color: blackText,),
                       SizedBox(width: 2),
                       Text(user.favFoods[index].numberOfPeople.toString(),style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: blackText),),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top:8,left: 8),
                   child: Align(
                     alignment: Alignment.centerLeft,
                     child: Text(user.favFoods[index].description.toString().length > 80 ? user.favFoods[index].description.toString().substring(0,80)+"..." : user.favFoods[index].description.toString()
                       ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: blackText),),
                   ),
                 ),

               ]
           ),
         ),
       );
     },
   ) : Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Align(
    alignment: Alignment.topCenter,
    child: Text('You don\'t have any favorites :(',style: TextStyle(fontSize: 20))
    ),
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
    UserModel user = Warehouse().userModel;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top:35),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 0.4 * size.width,
                  height: 170,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow:[BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    )],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Calories burnt this week',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Center(child: Container(
                          height: 100,
                          child: WeeklyBarChartWidget(weeklyData: [1,5,6,5,9,6,6],maximumValueOnYAxis: 15,
                          ))),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: 0.9 * size.width,
              height: 150,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow:[BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                )],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Calories burnt this week',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Center(child: Container(
                      height: 100,
                      child: WeeklyBarChartWidget(weeklyData: [1,5,6,5,9,6,6],maximumValueOnYAxis: 15,
                      ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
