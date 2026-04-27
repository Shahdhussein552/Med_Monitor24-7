import 'package:flutter/material.dart';
import 'constants.dart';

class DynamicCirclePainter extends CustomPainter {
  final double xOffsetPercent;
  DynamicCirclePainter({required this.xOffsetPercent});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.primaryBlue..style = PaintingStyle.fill;

    double r = 38; // نصف قطر الدائرة المنحنية
    double x = size.width * xOffsetPercent;

    Path path = Path()
      ..moveTo(0, 30)
      ..lineTo(x - r - 15, 30)
      ..quadraticBezierTo(x - r, 30, x - r, 30 - 5)
      ..arcToPoint(Offset(x + r, 30 - 5), radius: Radius.circular(r), clockwise: false)
      ..quadraticBezierTo(x + r, 30, x + r + 15, 30)
      ..lineTo(size.width, 30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DynamicCirclePainter oldDelegate) =>
      oldDelegate.xOffsetPercent != xOffsetPercent;
}