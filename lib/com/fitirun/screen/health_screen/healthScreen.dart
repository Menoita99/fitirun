
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsHealthScreen.dart';
import 'package:fitirun/com/fitirun/screen/details_screen/detailsTrainScreen.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/healthItem.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/screenTitle.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/workoutItem.dart';
import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  PageController _controller = PageController(initialPage: 0);
  bool isFoodSelected = true;
  static const int pageTransictionTime = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
          ),
        ),
        body: getBody(),
        bottomNavigationBar: NavigationBottomBar.withColor(
            isFoodSelected ? health_food_color : workout_color));
  }

  Widget getBody() {
    return SafeArea(
      child: Column(
        children: [
          SearchContainer(isFoodSelected ? health_food_color : workout_color),
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
    );
  }

  Container getWorkoutButton() {
    return Container(
      width: 120,
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
      width: 120,
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
        icon: Icon(Icons.favorite),
        label: Text("Food"),
        textColor: isFoodSelected ? Colors.white : blackText,
      ),
    );
  }



  Padding getWorkoutItens() {
    List<TrainModel> workouts = List<TrainModel>.generate(100, (i) => TrainModel.fakeModel());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: workouts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 0,
            childAspectRatio: 0.85),
        itemBuilder: (context, index) => WorkoutItem(
            workout: workouts[index],
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsTrainScreen(item: workouts[index]),
                ))),
      ),
    );
  }

  Widget getHealthFoodItens() {
    List<FoodModel> food = List<FoodModel>.generate(100, (i) => FoodModel.fakeFood());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: food.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 0,
            childAspectRatio: 0.85),
        itemBuilder: (context, index) => HealthItem(
            food: food[index],
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsHealthScreen(item: food[index]),
                ))),
      ),
    );
  }
}

class SearchContainer extends StatefulWidget {
  Color _color;

  SearchContainer(this._color);

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget._color,
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
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: TextField(
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
                IconButton(
                  icon: Icon(Icons.filter_list),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
