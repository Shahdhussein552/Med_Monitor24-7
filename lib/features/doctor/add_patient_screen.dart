import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/app_models.dart';
import '../../models/user_profile.dart';
import '../../features/doctor/patient_status_screen.dart';

class AddPatientScreen extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onUpdate;

  static List<AdmissionRequest> allRequests = [];

  const AddPatientScreen({super.key, required this.user, required this.onUpdate});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final nurseController = TextEditingController();
  String gender = "Male";

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    phoneController.dispose();
    nurseController.dispose();
    super.dispose();
  }

  Future<void> sendPatientRequest() async {
    // التحقق من إدخال البيانات الأساسية
    if (nameController.text.isEmpty || nurseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill basic fields"))
      );
      return;
    }

    // إنشاء طلب الإضافة الجديد
    final newRequest = AdmissionRequest(
      doctorName: widget.user.name,
      patientName: nameController.text,
      timeSent: DateFormat('hh:mm a').format(DateTime.now()),
      status: "pending",
      id: idController.text,
      age: ageController.text,
      phone: phoneController.text,
      gender: gender,
      height: heightController.text,
      weight: weightController.text,
    );

    // إضافة الطلب للقائمة
    AddPatientScreen.allRequests.add(newRequest);

    // الانتقال لشاشة حالة المريض (التي صممت بناءً على الصورة)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientStatusScreen(status: 'pending'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color lightBlueBg = Color(0xFFF4F7FF);
    const Color primaryColor = Color(0xFF719BFF);
    const Color darkText = Color(0xFF2E5AAC);

    return Scaffold(
      backgroundColor: lightBlueBg,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Add patient",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            buildField("Name", nameController, darkText),
            buildField("ID", idController, darkText),
            buildField("Age", ageController, darkText),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender",
                  style: TextStyle(fontWeight: FontWeight.bold, color: darkText, fontSize: 16)),
            ),
            Row(
              children: [
                _buildGenderOption("Male", primaryColor, darkText),
                const SizedBox(width: 30),
                _buildGenderOption("Female", primaryColor, darkText),
              ],
            ),
            buildField("Height", heightController, darkText),
            buildField("Weight", weightController, darkText),
            buildField("Companion Phone", phoneController, darkText),
            buildField("Nurse Name", nurseController, darkText),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: sendPatientRequest,
                child: const Text("Send Request",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, Color activeColor, Color textColor) {
    bool isSelected = gender == label;
    return GestureDetector(
      onTap: () => setState(() => gender = label),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: activeColor, width: 2),
            ),
            child: Icon(Icons.check,
                size: 18,
                color: isSelected ? Colors.white : Colors.transparent),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 18, color: textColor)),
        ],
      ),
    );
  }

  Widget buildField(String title, TextEditingController controller, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFADC4F8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF719BFF))),
          ),
        ),
      ],
    );
  }
}