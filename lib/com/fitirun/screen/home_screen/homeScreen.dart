import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(bottomNavigationBar: NavigationBottomBar(),);
  }
}
