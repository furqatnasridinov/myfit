import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MediumWave extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(71.5, 85);
    path_0.cubicTo(-6.9, 69.8, -60.1667, 118.333, -77, 144.5);
    path_0.cubicTo(-72.1667, 176.5, -62.5, 241.1, -62.5, 243.5);
    path_0.cubicTo(-62.5, 245.9, 255.167, 222.167, 414, 210);
    path_0.lineTo(421, 0);
    path_0.cubicTo(393.333, 6.83333, 365.5, 58.5, 289, 95);
    path_0.cubicTo(212.5, 131.5, 169.5, 104, 71.5, 85);
    path_0.close();

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4586667, size.height * 0.3975000),
        Offset(size.width * 0.4586667, size.height * 1.275000),
        [const Color.fromRGBO(6, 91, 255, 0.07), Colors.white.withOpacity(0.2)],
        [0, 1]);
    canvas.drawPath(path_0, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
