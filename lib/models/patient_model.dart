// lib/models/patient_model.dart

class PatientData {
  final String name, nurse, illness;
  final int age, bpm, brainActivity, respRate;

  const PatientData({
    required this.name,
    required this.age,
    required this.nurse,
    required this.illness,
    required this.bpm,
    required this.brainActivity,
    required this.respRate,
  });
}

class PatientBed {
  final String name;
  final int age;
  final String nurse;
  final String illness;

  const PatientBed({
    required this.name,
    required this.age,
    required this.nurse,
    required this.illness,
  });
}