import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';

class DetailsTrainScreen extends StatelessWidget {
  const DetailsTrainScreen({
    Key key,
    @required this.item,
  }) : super(key: key);

  final TrainModel item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                    IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.89,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: TrainModel.getDifficultyColor(
                                          item.difficulty),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    TrainModel.getDifficultyPhrase(
                                            item.difficulty)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            titleText("Description"),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.description,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[500]),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            titleText("Exercises"),
                            SizedBox(height: 20),
                            Column(
                                children: item.train
                                    .map((e) => _ExerciseItem(item: e))
                                    .toList()),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => print("Workout starting"),
                              child: Container(
                                height: 50,
                                width: size.width - 10,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: pastel_blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Center(
                                    child: Text(
                                  "Start Workout",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                )),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget titleText(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final ExerciceModel item;

  const _ExerciseItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Container(
        height: 50,
        width: size.width - 10,
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
                  item.series.toString(),
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
                    item.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.bodyPart,
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
