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
      padding: EdgeInsets.fromLTRB(20.0,5,0,5),
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