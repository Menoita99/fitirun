
import 'dart:ui';

import 'package:flutter/material.dart';

//colors
const health_food_color =  Color(0xffb5ead7);
const workout_color =  Color(0xffff9aa2);
const blackText = Colors.black54;
const homeScreen_color = Color(0xff557571);
const homeScreen_purple_color = Color(0xff726a95);
const white = Colors.white;
const purple = Color(0xFF6F35A5);
const pastel_blue = Color(0xFFAFDEFA);
const pastel_green = health_food_color;
const pastel_orange = Color(0xFFFFC984);
const pastel_red = workout_color;
const pastel_pink = Color(0xFFE5B3BB);
const pastel_yellow = Color(0xFFE5DB9C);
const pastel_brown = Color(0xFFD0BCAC);
const pastel_brown_orange = Color(0xFFE6A57E);
const pastel_salmon = Color(0xFFF9968B);
const pastel_dark_purple = Color(0xFFBEB4C5);
const pastel_dark_grey = Color(0xFF7B92AA);
const suave_pink = Color(0xFFDEC4D6);
const strong_pink = Color(0xFFC54B6C);
const strong_orange = Color(0xFFF27348);
const dark_blue = Color(0xFF200087);


// navigation bar colors
const List<Color> navColors = [
  Color(0xffc7ceea),
  pastel_blue,
  health_food_color,
  Color(0xfff2f0cb),
];


// Constants
const border_radius = 20.0;
const padding_value = 16.0;

class CustomColors {
  static const kLightPinkColor = Color(0xffF3BBEC);
  static const kYellowColor = Color(0xffF3AA26);
  static const kCyanColor = Color(0xff0eaeb4);
  static const kPurpleColor = Color(0xff533DC6);
  static const kPrimaryColor = Color(0xff39439f);
  static const kBackgroundColor = Color(0xffF3F3F3);
  static const kLightColor = Color(0xffc4bbcc);
}

class CustomTextStyle {
  static const dayTabBarStyleInactive = TextStyle(
    color: CustomColors.kLightColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const dayTabBarStyleActive = TextStyle(
    color: CustomColors.kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const metricTextStyle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25);
}


