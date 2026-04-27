import 'package:flutter/material.dart';
import 'dart:math';

class MonitorScreen extends StatefulWidget {
  final int bpm;           // نبضات القلب
  final int brainActivity; // نشاط الدماغ
  final int respRate;      // معدل التنفس

  const MonitorScreen({
    super.key,
    required this.bpm,
    required this.brainActivity,
    required this.respRate,
  });

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // تحكم في سرعة الحركة من هنا (Duration)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020E1A), // لون الخلفية الداكن (شاشة طبية)
      child: Row(
        children: [
          // القسم الجانبي: الأرقام الحيوية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _vitalLabel('${widget.bpm}', 'BPM', const Color(0xFF00FF88)),
                _vitalLabel('${widget.brainActivity}', '%', const Color(0xFF719EFF)),
                _vitalLabel('${widget.respRate}', 'RPM', const Color(0xFF00FF88)),
              ],
            ),
          ),
          // القسم الرئيسي: رسم الموجات المتحركة
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _waveRow(_WaveType.ecg, const Color(0xFF00FF88), _controller.value),
                    _waveRow(_WaveType.brain, const Color(0xFF719EFF), _controller.value),
                    _waveRow(_WaveType.resp, const Color(0xFF00FF88), _controller.value),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ودجت لعرض الرقم والوحدة
  Widget _vitalLabel(String value, String unit, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(unit, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
      ],
    );
  }

  Widget _waveRow(_WaveType type, Color color, double animationValue) {
    return Expanded(
      child: CustomPaint(
        painter: _WavePainter(type: type, color: color, animationValue: animationValue),
        child: Container(),
      ),
    );
  }
}

enum _WaveType { ecg, brain, resp }

class _WavePainter extends CustomPainter {
  final _WaveType type;
  final Color color;
  final double animationValue;

  _WavePainter({required this.type, required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    double mid = size.height / 2;
    double width = size.width;
    double offset = animationValue * width;

    if (type == _WaveType.ecg) {
      // رسم موجة القلب (ضربات محددة)
      for (double i = -40; i < width; i += 50) {
        double x = (i + offset) % (width + 50) - 50;
        path.moveTo(x, mid);
        path.lineTo(x + 15, mid);
        path.lineTo(x + 18, mid - 20); // القمة
        path.lineTo(x + 22, mid + 20); // القاع
        path.lineTo(x + 25, mid);
        path.lineTo(x + 50, mid);
      }
    } else {
      // رسم موجات الدماغ والتنفس (موجات جيبية Sinusoidal)
      for (double i = 0; i < width; i++) {
        double speed = (type == _WaveType.brain) ? 3 : 1.5;
        double amplitude = (type == _WaveType.brain) ? 10 : 6;
        double y = mid + sin((i + offset * speed) * 0.08) * amplitude;

        if (i == 0) path.moveTo(i, y);
        else path.lineTo(i, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}