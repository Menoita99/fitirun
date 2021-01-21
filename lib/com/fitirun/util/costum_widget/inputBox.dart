
import 'package:fitirun/com/fitirun/util/costum_widget/text_field_container.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {

  final String hintText;

  const InputBox({Key key, this.hintText}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        cursorColor: Color(0xFF6F35A5),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
