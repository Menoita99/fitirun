import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/widgets/screenTitle.dart';
import 'package:flutter/material.dart';

class DetailsHealthScreen extends StatelessWidget {
  const DetailsHealthScreen({
    Key key,
    @required this.item,
  }) : super(key: key);

  final FoodModel item;
  static const double leftColumnWidth = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: blackText),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.favorite_border, color: blackText)),
          ],
        ),
        body: getBody(context));
  }

  Widget getBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    ScreenTitle(item.title, blackText),
                    Container(
                      height: 310,
                      //  width: size.width -  leftColumnWidth - 15, //10 from this padding and 5 from buildStatusBox
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(item.image),
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: padding_value,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  buildStatusBox( item.calories, 'Calories', 'Kca'),
                                  SizedBox(height: 25),
                                  buildStatusBox(item.carbohydrates, 'Carbo', 'g'),
                                  SizedBox(height: 25),
                                  buildStatusBox( item.protein, 'Protein', 'g'),
                                  SizedBox(height: 25),
                                  buildStatusBox( item.preparationTime, 'Time', 'min'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 8,top:20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Recipe",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    recipeText(),
                  ]
                ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Column recipeText() {
    return Column(children: item.recipe.map((e) =>
        Padding(
          padding: const EdgeInsets.only(top:5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(e.toString(),
              style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500]),
              textAlign: TextAlign.start,
            ),
          ),
        )
    ).toList());
  }




  Widget buildStatusBox(int value, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        height: 50,
        width: leftColumnWidth,
        padding: EdgeInsets.all(5),
        // padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    )
                  ]),
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
