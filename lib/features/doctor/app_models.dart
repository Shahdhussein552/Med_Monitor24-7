class StatCardData {
  final int value;
  final String label;
  StatCardData({required this.value, required this.label});
}

class AgeGroupData {
  final String title;
  final String range;
  final int count;
  final String imagePath;
  AgeGroupData({
    required this.title,
    required this.range,
    required this.count,
    required this.imagePath,
  });
}

class ProfileFieldData {
  final String label;
  final String value;
  ProfileFieldData({required this.label, required this.value});
}

class AdmissionRequest {
  final String doctorName;
  final String patientName;
  final String timeSent;
  final String status;
  final String? id;
  final String? age;
  final String? phone;
  final String? gender;
  final String? height;
  final String? weight;

  AdmissionRequest({
    required this.doctorName,
    required this.patientName,
    required this.timeSent,
    this.status = "pending",
    this.id,
    this.age,
    this.phone,
    this.gender,
    this.height,
    this.weight,
  });
}