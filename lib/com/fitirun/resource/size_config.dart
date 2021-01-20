import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double scrWidth;
  static double scrHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    scrWidth = _mediaQueryData.size.width;
    scrHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = scrWidth / 100;
    blockSizeVertical = scrHeight / 100;
  }
}