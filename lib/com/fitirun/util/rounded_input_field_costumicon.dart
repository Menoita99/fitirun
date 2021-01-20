import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'text_field_container.dart';

class RoundedInputFieldCostumIcon extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputFieldCostumIcon({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: purple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: purple,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
