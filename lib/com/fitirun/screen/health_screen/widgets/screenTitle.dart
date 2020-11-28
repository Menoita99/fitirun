import 'package:flutter/material.dart';

class ScreenTitle extends StatefulWidget {
  String _title;

  ScreenTitle(this._title);

  @override
  _ScreenTitleState createState() => _ScreenTitleState();
}

class _ScreenTitleState extends State<ScreenTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(15.0),
      child: Text(
        widget._title,
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}