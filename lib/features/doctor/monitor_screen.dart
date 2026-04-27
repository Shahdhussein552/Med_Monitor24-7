import 'package:flutter/material.dart';
import 'package:med_monitor/features/doctor/wave_painter.dart';
import 'patient_model.dart';

class MonitorScreen extends StatefulWidget {
  final PatientData patient;
  const MonitorScreen({super.key, required this.patient});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          // بدون height — بياخدها من الـ parent
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF020E1A), Color(0xFF041830)],
            ),
          ),
          child: Row(
            children: [
              // Left Panel: Vitals
              SizedBox(
                width: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _vitalLabel('${widget.patient.bpm}', 'BPM',
                        const Color(0xFF00FF88)),
                    _vitalLabel('${widget.patient.brainActivity}', '%',
                        const Color(0xFF719EFF)),
                    _vitalLabel('${widget.patient.respRate}', 'RPM',
                        const Color(0xFFFFD700)),
                  ],
                ),
              ),
              // Middle: Waves
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _waveRow(WaveType.ecg, const Color(0xFF00FF88),
                        _controller.value),
                    _waveRow(WaveType.brain, const Color(0xFF719EFF),
                        _controller.value),
                    _waveRow(WaveType.resp, const Color(0xFFFFD700),
                        _controller.value),
                  ],
                ),
              ),
              // Right Panel: Extra Stats
              Container(
                width: 70,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statBox('EtO2', '98', 'mOs', const Color(0xFF00FF88)),
                    _statBox('NIBP', '120/80', '(93)', const Color(0xFFFF4444)),
                    _statBox('TEMP', '36.6', '°C', const Color(0xFF719EFF)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _vitalLabel(String value, String unit, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unit,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _waveRow(WaveType type, Color color, double phase) {
    return SizedBox(
      height: 35,
      child: CustomPaint(
        painter: WavePainter(type: type, color: color, phase: phase),
        child: Container(),
      ),
    );
  }

  Widget _statBox(String label, String val1, String val2, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 7),
        ),
        Text(
          val1,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          val2,
          style: TextStyle(color: color.withOpacity(0.6), fontSize: 7),
        ),
      ],
    );
  }
}