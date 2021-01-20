import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';

class TextFieldContainerCustom extends StatelessWidget {
  final Widget child;
  final double width;
  const TextFieldContainerCustom({
    Key key,
    this.child, this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * width,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
