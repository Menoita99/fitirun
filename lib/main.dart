import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:flutter/material.dart';

import 'com/fitirun/screen/home_screen/homeScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: true,
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Nunito',
    ),
    initialRoute: '/',
    routes: getRoutes(),
  ));
}
