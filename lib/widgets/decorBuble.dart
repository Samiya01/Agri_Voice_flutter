import 'package:agri_voice/values.dart';
import 'package:flutter/material.dart';

class MyDecorBubble extends StatelessWidget {
  double circleRadius;
  Color circleColor;

  MyDecorBubble(
      {Key? key, required this.circleRadius, required this.circleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
          painter:
              DecorBubble(circleRadius: circleRadius, circleColor: circleColor),
        ));
  }
}

class DecorBubble extends CustomPainter {
  double circleRadius;
  Color circleColor;

  DecorBubble({required this.circleRadius, required this.circleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(3, 0), circleRadius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
