import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    Paint paint = Paint();

    // top right triangle
    Path trianglePath = Path();
    trianglePath.moveTo(0, height * 0.15);
    trianglePath.lineTo(width * 0.12, height * 0.3);
    trianglePath.lineTo(width * 0.1, 0);
    trianglePath.lineTo(0, 0);
    trianglePath.close();

    paint.color = Color(0xFF881098);
    canvas.drawPath(trianglePath, paint);

    // middle rectangle
    Path rectPath = Path();
    rectPath.moveTo(width * 0.75, 0);
    rectPath.lineTo(width * 0.85, 0);
    rectPath.lineTo(width * 0.85, height * 0.25);
    rectPath.lineTo(width * 0.75, height * 0.25);
    rectPath.lineTo(width * 0.75, 0);
    rectPath.close();

    paint.color = Color(0xFFB61EC9);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(rectPath, paint);

    // middle arc
    Path arcPath = Path();
    arcPath.moveTo(width * 0.22, height * 0.3);
    arcPath.lineTo(width * 0.35, height * 0.3);
    arcPath.lineTo(width * 0.35, height * 0.08);
    arcPath.cubicTo(width * 0.25, height * 0.1, width * 0.22, height * 0.16, width * 0.22, height * 0.25);
    arcPath.close();

    paint.color = Color(0xFF851693);
    canvas.drawPath(arcPath, paint);

    // right semi-circle
    Path circlePath  =  Path();
    circlePath.moveTo(width, height * 0.8);
    circlePath.lineTo(width * 0.86, height * 0.8);
    circlePath.quadraticBezierTo(width * 0.85, height * 0.9, width, height * 0.95);
    circlePath.close();

    paint.color = Color(0xFF5D1166);
    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
