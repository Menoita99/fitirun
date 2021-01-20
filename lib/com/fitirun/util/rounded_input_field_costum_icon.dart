import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/screen/setting_screen/components/text_field_container_size_ajustable.dart';
import 'package:flutter/material.dart';
import 'text_field_container.dart';

class RoundedInputFieldCustomIcon extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType type;
  const RoundedInputFieldCustomIcon({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainerCustom(
      width: 0.7,
      child: TextField(
        keyboardType: type,
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
