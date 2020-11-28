import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/healthItem.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/screenTitle.dart';
import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
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
        bottomNavigationBar: NavigationBottomBar());
  }

  Widget getBody() {
    return SafeArea(
      child: Column(
        children: [
          ScreenTitle("Be better\nBe healthier"),
          SearchContainer(health_food_color),

          Expanded(
            child: PageView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 0,
                        childAspectRatio: 0.85),
                    itemBuilder: (context, index) => HealthItem(
                        food: FoodModel.fakeFood(),
                        onPress: () => print("Clicked $index")),
                  ),
                )
              ],
            ),
          )
        ],
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
        child: Row(
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
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.88)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(border_radius))),
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
      ),
    );
  }
}
