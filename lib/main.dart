import 'file:///C:/Users/rui.menoita/StudioProjects/fitirun/lib/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:flutter/material.dart';

import 'com/fitirun/screen/home_screen/homeScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Nunito',
    ),
     initialRoute: '/',
     routes: getRoutes(),
  ));
}
