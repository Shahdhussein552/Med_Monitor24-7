import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../doctor/custom_painter.dart';

class BedsScreen extends StatefulWidget {
  final PatientBed? newPatient;
  const BedsScreen({super.key, this.newPatient});

  @override
  State<BedsScreen> createState() => _BedsScreenState();
}

class _BedsScreenState extends State<BedsScreen> {
  // الألوان والتنسيقات الثابتة
  static const Color _headerBlue = Color(0xFF719EFF);
  static const Color _mainBgColor = Color(0xFFEDF3FF);
  static const Color _sharpFrameColor = Color(0xFF8DAEF2);
  static const Color _numberGrey = Color(0xFF626262);
  static const Color _redDelete = Color(0xFFE53935);
  static const Color _whiteBtnBg = Color(0xFFFFFFFF);
  static const Color _pureBlack = Color(0xFF000000);

  late List<PatientBed> _activePatients;

  @override
  void initState() {
    super.initState();
    // قائمة المرضى الأولية
    _activePatients = [
      const PatientBed(name: 'Ahmed', age: 25, nurse: 'Soha', illness: 'Cancer'),
      const PatientBed(name: 'Ali', age: 31, nurse: 'Soha', illness: 'Heart attack'),
      const PatientBed(name: 'Mona', age: 20, nurse: 'Mahmoud', illness: 'Broken'),
    ];

    if (widget.newPatient != null) {
      _activePatients.add(widget.newPatient!);
    }
  }

  void _addNewPatient() {
    if (_activePatients.length < 5) {
      setState(() {
        _activePatients.add(
          const PatientBed(
              name: 'New Patient',
              age: 0,
              nurse: 'Not Assigned',
              illness: 'General Checkup'
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBgColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                ..._activePatients.map((patient) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildOccupiedBedCard(patient),
                )),
                if (_activePatients.length < 5) _buildEmptyBedCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _headerBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    children: [
                      const TextSpan(text: 'Beds : ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '${_activePatients.length}', style: const TextStyle(color: _numberGrey)),
                      const TextSpan(text: ' / 5', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              // تم حذف أيقونة الإشعارات من هنا لإخفائها
              const SizedBox(width: 20), // مساحة بديلة لضمان توازن النص في المنتصف
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupiedBedCard(PatientBed patient) {
    return Container(
      decoration: BoxDecoration(
        color: _mainBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sharpFrameColor, width: 2.5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13.5)),
            child: Container(
              height: 150,
              width: double.infinity,
              color: _pureBlack,
              child: _buildFakeMonitor(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildInfoItem('Name: ', patient.name)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildInfoItem('Age: ', '${patient.age}')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildInfoItem('Nurse: ', patient.nurse)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildInfoItem('Illness: ', patient.illness)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _activePatients.remove(patient);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _whiteBtnBg,
                    foregroundColor: _redDelete,
                    elevation: 1,
                    side: const BorderSide(color: _redDelete, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Delete Patient', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildEmptyBedCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: _mainBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sharpFrameColor, width: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No Patient added yet',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Opacity(
            opacity: 0.25,
            child: Icon(Icons.hotel, size: 80, color: _headerBlue),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addNewPatient,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: const Text('Click to add patient',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _headerBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeMonitor() {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: EcgPainter())),
        const Positioned(
          top: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonitorLabel(value: '74', unit: 'BPM', color: Color(0xFF00E5FF)),
              MonitorLabel(value: '98', unit: '%SpO2', color: Color(0xFF69FF47)),
              MonitorLabel(value: '34', unit: 'RESP', color: Color(0xFFFFD54F)),
            ],
          ),
        ),
      ],
    );
  }
}

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