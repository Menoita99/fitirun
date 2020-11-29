import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:flutter/material.dart';

class WorkoutItem extends StatelessWidget {
  const WorkoutItem({
    Key key,
    @required this.workout, this.onPress,
  }) : super(key: key);

  final WorkoutModel workout;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: new CachedNetworkImage(
              imageUrl: workout.image,
              height: 140.0,
              width: 140.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              workout.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
