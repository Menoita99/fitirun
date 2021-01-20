import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/resource/size_config.dart';
import 'package:fitirun/com/fitirun/resource/heading_widget.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsHealthScreen.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsTrainScreen.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/healthItem.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/workoutItem.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/warehouse.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int displayedItems = 10; //Items displayed on popular workouts and foods



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Warehouse().listeners.add((userModel) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        children: [
          _buildDashboardCards()
        ],
      ),
    );
  }

  Widget _buildDashboardCards() {
    UserModel user = Warehouse().userModel;
    num runtrg = 2500;//get goals from user
    num stptrg = 4000;//get goals from user
    num runach = getMetric(user, 'running');
    num stpach = getMetric(user, 'steps');

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColors.kBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeadingWidget(text1: 'ACTIVITY', text2: 'Show All',),
              _buildCard(
                  color1: CustomColors.kLightPinkColor,
                  color2: CustomColors.kCyanColor,
                  color3: CustomColors.kYellowColor,
                  color4: CustomColors.kPurpleColor,
                  metricAchieved: runach.toString(),
                  metricTarget: runtrg.toString(),
                  value: runach/runtrg,
                  iconPath: 'assets/icons/running.png',
                  metricType: 'Running',),
              _buildCard(
                  color1: CustomColors.kCyanColor,
                  color2: CustomColors.kYellowColor,
                  color3: CustomColors.kPurpleColor,
                  color4: CustomColors.kLightPinkColor,
                  metricAchieved: stpach.toString(),
                  metricTarget: stptrg.toString(),
                  value: stpach/stptrg,
                  iconPath: 'assets/icons/footprints.png',
                  metricType: 'Steps',),
              HeadingWidget(text1: 'Popular Workouts', text2: '',),
              getWorkoutItems(),
              HeadingWidget(text1: 'Popular Foods', text2: '',),
              getFoodItems(),
            ],

          ),
        ),
      ),
    );
  }

  Padding getFoodItems() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: buildPopularFoods()
    );
  }

  Padding getWorkoutItems() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: buildPopularWorkouts()
    );
  }

  Widget buildPopularWorkouts(){
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().workouts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        List<TrainModel> allWorkouts = List();
        List<TrainModel> featuredWorkouts = List();
        for(int i = 0; i<snapshot.data.docs.length; i++){
          TrainModel workout = TrainModel.fromDoc(snapshot.data.docs[i]);
            allWorkouts.add(workout);
        }
        if(allWorkouts.length > 0){
          for(int i = 0; i< displayedItems; i++){
            int r = Random().nextInt(allWorkouts.length);
            featuredWorkouts.add(allWorkouts[r]);
            allWorkouts.removeAt(r);
        }}

        return featuredWorkouts.isNotEmpty ? Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredWorkouts.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: WorkoutItem(
                  workout: featuredWorkouts[index],
                  onPress: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsTrainScreen(item: featuredWorkouts[index]),
                      ))),
            ),
          ),
        ) : Center(child: Text("No popular workouts"),);
      },

    );
  }

  Widget buildPopularFoods() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().foods,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        List<FoodModel> allFoods = List();
        List<FoodModel> featuredFoods = List();
        for (int i = 0; i < snapshot.data.docs.length; i++) {
          FoodModel food = FoodModel.fromDoc(snapshot.data.docs[i]);
          allFoods.add(food);
        }
        if(allFoods.length > 0){
        for (int i = 0; i < displayedItems; i++) {
          int r = Random().nextInt(allFoods.length);
          featuredFoods.add(allFoods[r]);
          allFoods.removeAt(r);
        }}

        return featuredFoods.isNotEmpty ? Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredFoods.length,
            itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HealthItem(
                      food: featuredFoods[index],
                      onPress: () =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsHealthScreen(
                                        item: featuredFoods[index]),
                              ))),
                ),
          ),
        ) : Center(child: Text("No popular foods"),);
      },

    );
  }
  num getMetric(UserModel user, String s) {
    int sum = 0;
    var now = new DateTime.now();
    switch (s) {
      case 'running':
          if (user != null && user.steps!= null &&  user.steps.length > 0) {
            for (int i = 0; i < user.steps.length; i++) {
              if (user.steps[i].time.day == now.day)
                sum += user.steps[i].steps;
              else
                break;
            }
            return sum;
          } else
            return 1000;
        break;
      case 'steps':
        if (user != null && user.statistics.length > 0) {
          // for(int i; i < user.statistics.length; i++) {
          //   if (user.statistics[i].time.day==now.day)
          //     sum+=user.statistics[i];
          //   else
          //     break;
          // }
          return sum;
        } else
          return 1000;
        break;
    }

  }

  Container _buildCard(
      {Color color1,
        Color color2,
        Color color3,
        Color color4,
        String metricType,
        String metricAchieved,
        String metricTarget,
        double value,
        String iconPath}) {
    return Container(
      height: SizeConfig.blockSizeVertical * 30,
      width: SizeConfig.blockSizeHorizontal * 85,
      margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1),
      decoration: BoxDecoration(
          color: CustomColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: SizeConfig.blockSizeVertical * 10, // 12% of screen
              width:
              SizeConfig.blockSizeHorizontal * 10, // 23% of width of screen
              decoration: BoxDecoration(
                  color: color3,
                  borderRadius: BorderRadius.only(
                      topRight:
                      Radius.circular(SizeConfig.blockSizeVertical * 5),
                      bottomRight:
                      Radius.circular(SizeConfig.blockSizeVertical * 5))),
            ),
          ),
          Positioned(
            top: SizeConfig.blockSizeVertical * 3,
            left: SizeConfig.blockSizeHorizontal * 6,
            child: Container(
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metricType,
                        style: TextStyle(color: CustomColors.kLightColor),
                      ),
                      Text(
                        metricAchieved,
                        style: CustomTextStyle.metricTextStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: SizeConfig.blockSizeVertical * 5,
            left: SizeConfig.blockSizeHorizontal * 6,
            child: Container(
              child: Row(
                children: [
                  Text(
                    metricTarget.toString(),
                    style: CustomTextStyle.metricTextStyle,
                  ),
                  Text(
                    ' m',
                    style: TextStyle(color: CustomColors.kLightColor),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: SizeConfig.blockSizeVertical * 1, // 12% of screen
              width:
              SizeConfig.blockSizeHorizontal * 75, // 23% of width of screen
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                    value: value,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: CustomColors.kLightColor.withOpacity(0.2)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
