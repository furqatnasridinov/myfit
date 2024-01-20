import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TopWave extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(46.5, 63.5);
    path_0.cubicTo(-31.9, 48.3, -60.1667, 89.3333, -77, 115.5);
    path_0.cubicTo(-72.1667, 147.5, -62.5, 212.1, -62.5, 214.5);
    path_0.cubicTo(-62.5, 216.9, 255.167, 193.167, 414, 181);
    path_0.lineTo(424.5, 0);
    path_0.cubicTo(396.833, 6.83333, 335.5, 51.5, 259, 88);
    path_0.cubicTo(182.5, 124.5, 144.5, 82.5, 46.5, 63.5);
    path_0.close();

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4586667, size.height * 0.2348837),
        Offset(size.width * 0.4586667, size.height * 1.051163),
        [const Color.fromRGBO(6, 91, 255, 0.07), Colors.white.withOpacity(0.1)],
        [0, 1]);
    canvas.drawPath(path_0, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
