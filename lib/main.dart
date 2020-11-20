import 'package:flutter/material.dart';

import 'com/fitirun/view/homeView.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    home: MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}
