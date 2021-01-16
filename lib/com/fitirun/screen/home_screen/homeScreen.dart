import 'dart:math';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/healthItem.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/workoutItem.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:provider/provider.dart';

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
    final AuthService _auth = AuthService();
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: blackText),
          onPressed: () => print("something"),
        ),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {

                await _auth.signOut(user);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout),
              label: Text(
                "Logout",
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
      body: SingleChildScrollView(child: getBody()),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }

  Widget getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Be the best\nVersion of yourself.",
            style: TextStyle(
              fontSize: 25,
              color: homeScreen_color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ChartContainer(fillData()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getWorkoutButton(),
              getRecipeButton(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text("Popular workouts",
              style: TextStyle(
                  fontSize: 25,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                  color: homeScreen_purple_color,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 200.0,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 180, child: WorkoutItem(workout: getRandomWorkOut())),
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10,
                );
              },
              padding: EdgeInsets.only(left: 5),
              scrollDirection: Axis.horizontal,
            )),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text("Popular recipes",
              style: TextStyle(
                  fontSize: 25,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                  color: homeScreen_purple_color,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 200.0,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 180, child: HealthItem(food: FoodModel.fakeFood())),
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10,
                );
              },
              padding: EdgeInsets.only(left: 5),
              scrollDirection: Axis.horizontal,
            )),
      ],
    );
  }

  getWorkoutButton() {
    return Container(
      decoration: BoxDecoration(
          color: workout_color,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: FlatButton.icon(
        onPressed: () {
          print("Eu sou o Rei == Rui Gei");
        },
        icon: Icon(Icons.fitness_center),
        label: Text(
          "Random Workout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  getRecipeButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: health_food_color),
      child: FlatButton.icon(
        onPressed: () {
          print("Eu sou o Rei == Rui Gei");
        },
        icon: Icon(Icons.favorite),
        label: Text(
          "Random recipe",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  List<double> fillData() {
    List<double> data = new List(7);
    var rng = new Random();
    for (int i = 0; i < 7; i++) {
      data[i] = 2000.0 + rng.nextDouble() * 1000;
    }
    return data;
  }
}

// ignore: must_be_immutable
class ChartContainer extends StatefulWidget {
  List<double> data = new List(7);

  ChartContainer(this.data);

  @override
  _ChartContainerState createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xffbedbbb),
            border: Border.all(color: Color(0xffbedbbb), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: new Sparkline(
          data: widget.data,
          fillMode: FillMode.below,
          fillGradient:
              LinearGradient(colors: [Color(0xff70e1f5), Color(0xffffd194)]),
          pointsMode: PointsMode.all,
          pointColor: homeScreen_purple_color,
          pointSize: 10.0,
        ),
      ),
    );
  }
}
