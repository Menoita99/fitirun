import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsHealthScreen.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsTrainScreen.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/healthItem.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/screenTitle.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/workoutItem.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HealthScreen extends StatefulWidget {
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  PageController _controller = PageController(initialPage: 0);
  bool isFoodSelected = true;
  static const int pageTransictionTime = 1000;
  List<FoodModel> food = List();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: getBody());
     //   bottomNavigationBar: NavigationBottomBar.withColor(
     //       isFoodSelected ? health_food_color : workout_color));
  }

  Widget getBody() {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top:10),
        child: Column(
          children: [
            searchContainer(isFoodSelected ? health_food_color : workout_color),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getFoodButton(),
                  getWorkoutButton(),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: new NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [getHealthFoodItens(), getWorkoutItens()],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container getWorkoutButton() {
    return Container(
      width: 125,
      decoration: BoxDecoration(
        color: isFoodSelected ? Colors.transparent : workout_color,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: FlatButton.icon(
        onPressed: () => {
          _controller.animateToPage(1,
              duration: Duration(milliseconds: pageTransictionTime),
              curve: Curves.easeInOut),
          setState(() => isFoodSelected = false)
        },
        icon: Icon(Icons.fitness_center),
        label: Text("Workout"),
        textColor: isFoodSelected ? blackText : Colors.white,
      ),
    );
  }

  Container getFoodButton() {
    return Container(
      width: 125,
      decoration: BoxDecoration(
        color: isFoodSelected ? health_food_color : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: FlatButton.icon(
        onPressed: () => {
          _controller.animateTo(0,
              duration: Duration(milliseconds: pageTransictionTime),
              curve: Curves.easeInOut),
          setState(() => isFoodSelected = true)
        },
        icon:  Icon(Icons.favorite),
        label: Text("Food"),
        textColor: isFoodSelected ? Colors.white : blackText,
      ),
    );
  }

  Padding getWorkoutItens() {
    //List<TrainModel> workouts = List<TrainModel>.generate(100, (i) => TrainModel.fakeModel());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: workoutItems(search)
    );
  }

  Widget getHealthFoodItens() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: foodItems(search),
    );
  }

  Widget searchContainer(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(border_radius)),
        ),
        child: Column(
          children: [
            ScreenTitle("Be Better\nBe Healthier"),
            Row(
              children: [
                Expanded(
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        onChanged: (value) => {
                          setState((){
                            search = value;
                          })
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(border_radius)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.88)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(border_radius))),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                            ),
                            hintText: 'search',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.88)),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget foodItems(String search) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().foods,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        List<FoodModel> filteredFoods = List();
        for(int i = 0; i<snapshot.data.docs.length; i++){
          FoodModel food = FoodModel.fromDoc(snapshot.data.docs[i]);
          if(food.title.contains(search))
            filteredFoods.add(food);
        }

        return filteredFoods.isNotEmpty ? GridView.builder(
          itemCount: filteredFoods.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 0,
              childAspectRatio: 0.85),
          itemBuilder: (context, index) => HealthItem(
              food: filteredFoods[index],
              onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsHealthScreen(item: filteredFoods[index]),
                  ))),
        ): Center(child: Text("No foods found"),);
      },
    );
  }

  Widget workoutItems(String search) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().workouts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        List<TrainModel> filteredWorkouts = List();
        for(int i = 0; i<snapshot.data.docs.length; i++){
          TrainModel workout = TrainModel.fromDoc(snapshot.data.docs[i]);
          if(workout.title.contains(search))
            filteredWorkouts.add(workout);
        }
        return filteredWorkouts.isNotEmpty ? GridView.builder(
          itemCount: filteredWorkouts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 0,
              childAspectRatio: 0.85),
          itemBuilder: (context, index) => WorkoutItem(
              workout: filteredWorkouts[index],
              onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsTrainScreen(item: filteredWorkouts[index]),
                  ))),
        ) : Center(child: Text("No workouts found"),);
      },
    );
  }
}