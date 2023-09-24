import 'dart:math' as math;

import 'package:flutter/material.dart';

class StarBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;
    var centerX = size.width / 2;
    var centerY = size.height / 2;

    var path = Path();

    var radius = size.width / 2;
    var inner = radius / 2;
    var rotation = math.pi / 2 * 3;
    var step = math.pi / 5;

    path.lineTo(centerX, centerY - radius);

    for (var i = 0; i < 5; i++) {
      var x = centerX + math.cos(rotation) * radius;
      var y = centerY + math.sin(rotation) * radius;
      path.lineTo(x, y);
      rotation += step;

      x = centerX + math.cos(rotation) * inner;
      y = centerY + math.sin(rotation) * inner;
      path.lineTo(x, y);
      rotation += step;
    }

    path.lineTo(centerX, centerY - radius);
    path.close();
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
