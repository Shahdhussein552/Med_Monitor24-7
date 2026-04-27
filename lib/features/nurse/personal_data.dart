import 'package:flutter/material.dart';
import '../doctor/app_models.dart'; // تأكد من استيراد الموديل

class PersonalDataScreen extends StatefulWidget {
  // ✅ إضافة الـ request هنا عشان نستقبل البيانات
  final AdmissionRequest request;

  const PersonalDataScreen({super.key, required this.request});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  // تعريف الـ Controllers
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _companionController;

  static const Color _primaryBlue = Color(0xFF719EFF);
  static const Color _bgColor = Color(0xFFEDF3FF);
  static const Color _textColor = Color(0xFF2E55A7);

  @override
  void initState() {
    super.initState();
    // ✅ تعبئة البيانات فور فتح الشاشة من كائن الـ request
    _nameController = TextEditingController(text: widget.request.patientName);
    _idController = TextEditingController(text: widget.request.id ?? "");
    _ageController = TextEditingController(text: widget.request.age ?? "");
    _genderController = TextEditingController(text: widget.request.gender ?? "");
    _heightController = TextEditingController(text: widget.request.height ?? "");
    _weightController = TextEditingController(text: widget.request.weight ?? "");
    _companionController = TextEditingController(text: widget.request.phone ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _companionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField(
                          label: 'Name',
                          controller: _nameController,
                          keyboardType: TextInputType.name),
                      _buildField(
                          label: 'ID',
                          controller: _idController,
                          keyboardType: TextInputType.number),
                      _buildField(
                          label: 'Age',
                          controller: _ageController,
                          keyboardType: TextInputType.number),
                      _buildField(label: 'Gender', controller: _genderController),
                      _buildField(
                          label: 'Height',
                          controller: _heightController,
                          keyboardType: TextInputType.number),
                      _buildField(
                          label: 'Weight',
                          controller: _weightController,
                          keyboardType: TextInputType.number),
                      _buildField(
                          label: 'Companion Phone',
                          controller: _companionController,
                          keyboardType: TextInputType.phone,
                          isLast: true),
                    ]))),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
        color: _primaryBlue,
        child: SafeArea(
            bottom: false,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 24)),
                  const Expanded(
                      child: Text('Personal data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700))),
                  const SizedBox(width: 24),
                ]))));
  }

  Widget _buildField(
      {required String label,
        required TextEditingController controller,
        TextInputType keyboardType = TextInputType.text,
        bool isLast = false}) {
    return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  color: _textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: _primaryBlue, width: 1.5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: _textColor, width: 2)))),
          const SizedBox(height: 10),
        ]));
  }
}