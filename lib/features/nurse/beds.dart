import 'package:flutter/material.dart';
// 1. المسار الصحيح للشاشة التفصيلية
import 'package:med_monitor/features/nurse/nurse_patient_details_screen.dart';
// 2. المسار الصحيح للموديل (تأكدي من اسم الـ package)
import 'package:med_monitor/models/patient_model.dart';
// 3. المسار الصحيح للـ MonitorScreen (عشان يحل الايرور الثاني)
import 'package:med_monitor/features/doctor/monitor_screen.dart';
import 'package:med_monitor/features/nurse/nurse_tasks_screen.dart';

class BedsScreen extends StatelessWidget {
  const BedsScreen({super.key});

  // قائمة البيانات (Data Source)
  static const List<PatientData> patients = [
    PatientData(
        name: 'Ahmed',
        age: 25,
        nurse: 'Soha',
        illness: 'Cancer',
        bpm: 74,
        brainActivity: 65,
        respRate: 34),
    PatientData(
        name: 'Ali',
        age: 31,
        nurse: 'Soha',
        illness: 'Heart attack',
        bpm: 82,
        brainActivity: 70,
        respRate: 18),
    PatientData(
        name: 'Mona',
        age: 20,
        nurse: 'Mahmoud',
        illness: 'Broken Bone',
        bpm: 68,
        brainActivity: 60,
        respRate: 22),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF3FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: patients.length,
              itemBuilder: (context, index) => BedCard(patient: patients[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ الهيدر المحدث مع زرار الرجوع وتوسيط النص
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF719EFF),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // إضافة زر الرجوع
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 48), // لموازنة مكان النص بسبب زر الرجوع
                    child: Text(
                      'Beds: 3/5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BedCard extends StatelessWidget {
  final PatientData patient;
  const BedCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PatientDetailScreen(patient: patient))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF719EFF), width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: MonitorScreen(patient: patient), // مفيش height محددة هنا!
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _infoText('Name: ', patient.name)),
                      Expanded(child: _infoText('Age: ', '${patient.age}')),
                    ],
                  ),
                  const Divider(height: 16, color: Color(0xFFD0D9E5)),
                  Row(
                    children: [
                      Expanded(child: _infoText('Nurse: ', patient.nurse)),
                      Expanded(child: _infoText('Illness: ', patient.illness)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
        children: [
          TextSpan(
              text: label,
              style: const TextStyle(
                  color: Color(0xFF626262), fontWeight: FontWeight.w500)),
          TextSpan(
              text: value,
              style: const TextStyle(
                  color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}