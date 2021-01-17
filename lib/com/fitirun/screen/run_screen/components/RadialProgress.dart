import 'package:vector_math/vector_math_64.dart' as math;
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';

class RadialProgress extends StatefulWidget {
  final double height, width, progress;
  final Color color;

  const RadialProgress({Key key, this.height, this.width, this.progress, this.color}) : super(key: key);

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress:  widget.progress,
        color: widget.color,
      ),
      child: Container(
        height: widget.height,
        width:  widget.width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: widget.color,
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "m left",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RadialPainter({this.progress,this.color=blackText});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}