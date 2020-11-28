import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
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
    FoodModel food = new FoodModel.fakeFood();
    return SafeArea(
      child: Column(
        children: [
          ScreenTitle("Be better\nBe healthier"),
          SearchContainer(health_food_color),
          Container(
            height: 180,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: new CachedNetworkImage(
                    imageUrl: food.image,
                    height: 140.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                      food.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ScreenTitle extends StatefulWidget {
  String _title;

  ScreenTitle(this._title);

  @override
  _ScreenTitleState createState() => _ScreenTitleState();
}

class _ScreenTitleState extends State<ScreenTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(15.0),
      child: Text(
        widget._title,
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w300,
        ),
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
