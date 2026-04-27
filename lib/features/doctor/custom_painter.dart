import 'package:flutter/material.dart';

class MonitorLabel extends StatelessWidget {
  final String value, unit;
  final Color color;
  const MonitorLabel({super.key, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        const SizedBox(width: 4),
        Text(unit, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class EcgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2.0..style = PaintingStyle.stroke;
    _drawPath(canvas, size, size.height * 0.25, const Color(0xFF00E5FF), paint, 1);
    _drawPath(canvas, size, size.height * 0.55, const Color(0xFF69FF47), paint, 2);
    _drawPath(canvas, size, size.height * 0.85, const Color(0xFFFFD54F), paint, 3);
  }

  void _drawPath(Canvas canvas, Size size, double yBase, Color color, Paint paint, int type) {
    final path = Path();
    paint.color = color;
    for (double x = 85; x < size.width - 10; x++) {
      double y = yBase;
      if (type == 1) {
        double phase = (x % 60) / 60;
        if (phase > 0.4 && phase < 0.5) y -= 25 * (phase - 0.4) * 10;
        if (phase >= 0.5 && phase < 0.6) y += 25 * (phase - 0.5) * 10;
      } else if (type == 2) {
        y += 5 * (3.14 * x / 20).hashCode.toDouble().sign;
      } else {
        y += 8 * (3.14 * x / 40).hashCode.toDouble().sign;
      }
      if (x == 85) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}