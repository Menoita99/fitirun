import 'package:flutter/material.dart';

class ScreenTitle extends StatefulWidget {
  final String _title;
  final Color _color;

  ScreenTitle(this._title,[this._color =  Colors.white]);

  @override
  _ScreenTitleState createState() => _ScreenTitleState();
}

class _ScreenTitleState extends State<ScreenTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(15.0,5,0,5),
      child: Text(
        widget._title,
        style: TextStyle(
          color: widget._color,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}