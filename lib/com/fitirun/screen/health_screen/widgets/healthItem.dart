import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:flutter/material.dart';

class HealthItem extends StatelessWidget {
  const HealthItem({
    Key key,
    @required this.food, this.onPress,
  }) : super(key: key);

  final FoodModel food;
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
              imageUrl: food.image,
              height: 140.0,
              width: 140.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
            child: Text(
              food.title,
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
