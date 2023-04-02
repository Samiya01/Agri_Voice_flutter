import 'package:agri_voice/values.dart';
import 'package:flutter/material.dart';

class MyDecorCircle extends StatelessWidget {
  double circleRadius;
  MyDecorCircle({Key? key,required this.circleRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(painter: DecorCircle(circleRadius: circleRadius),));
  }
}


class DecorCircle extends CustomPainter {
  double circleRadius;
  DecorCircle({required this.circleRadius});
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = decorCircleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(3, 0), circleRadius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}