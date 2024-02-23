import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class BottomWave extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(80.5, 37.9999);
    path_0.cubicTo(2.1, 22.7999, -60.1667, 54.3333, -77, 80.4999);
    path_0.cubicTo(-72.1667, 112.5, -62.5, 177.1, -62.5, 179.5);
    path_0.cubicTo(-62.5, 181.9, 255.167, 158.167, 414, 146);
    path_0.lineTo(426, 2.49988);
    path_0.cubicTo(398.333, 9.33321, 372.5, -14, 290.5, 16.4999);
    path_0.cubicTo(208.5, 46.9999, 178.5, 56.9999, 80.5, 37.9999);
    path_0.close();

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4586667, size.height * 0.1597938),
        Offset(size.width * 0.4586667, size.height * 1.969072), [
      const Color.fromRGBO(6, 91, 255, 0.07),
      Colors.white.withOpacity(0.22)
    ], [
      0,
      1
    ]);
    canvas.drawPath(path_0, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
