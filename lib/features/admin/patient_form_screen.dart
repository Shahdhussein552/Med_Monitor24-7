import 'package:flutter/material.dart';
import '../doctor/app_models.dart';
import '../admin/no_beds_super_admin.dart';

class PatientFormScreen extends StatefulWidget {
  final AdmissionRequest request;
  const PatientFormScreen({super.key, required this.request});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _ageController;
  late TextEditingController _nurseNameController;
  late TextEditingController _phoneController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();

    // سطر للتحقق من البيانات في شاشة الـ Debugging (Console)
    print("Data Received: Height=${widget.request.height}, Weight=${widget.request.weight}");

    _nameController = TextEditingController(text: widget.request.patientName);
    _idController = TextEditingController(text: widget.request.id ?? "");
    _ageController = TextEditingController(text: widget.request.age ?? "");
    _nurseNameController = TextEditingController(text: widget.request.doctorName);
    _phoneController = TextEditingController(text: widget.request.phone ?? "");

    // ربط الحقول بشكل صحيح مع التأكد من تحويلها لنص
    _heightController = TextEditingController(text: widget.request.height?.toString() ?? "");
    _weightController = TextEditingController(text: widget.request.weight?.toString() ?? "");

    _selectedGender = (widget.request.gender != null && widget.request.gender!.isNotEmpty)
        ? widget.request.gender!
        : "Male";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    _nurseNameController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF719EFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.request.doctorName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Name"),
            _buildTextField(_nameController),
            const SizedBox(height: 15),

            _buildLabel("ID"),
            _buildTextField(_idController),
            const SizedBox(height: 15),

            _buildLabel("Age"),
            _buildTextField(_ageController),
            const SizedBox(height: 15),

            _buildLabel("Gender"),
            Row(
              children: [
                _buildGenderOption("Male"),
                const SizedBox(width: 40),
                _buildGenderOption("FeMale"),
              ],
            ),
            const SizedBox(height: 15),

            _buildLabel("Height"),
            _buildTextField(_heightController),
            const SizedBox(height: 15),

            _buildLabel("Weight"),
            _buildTextField(_weightController),
            const SizedBox(height: 15),

            _buildLabel("Companion Phone"),
            _buildTextField(_phoneController),
            const SizedBox(height: 15),

            _buildLabel("Nurse Name"),
            _buildTextField(_nurseNameController),

            const SizedBox(height: 35),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BedsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF719EFF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    child: const Text("Approve", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF719EFF), width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Rejection", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 2),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF2E55A7), fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF719EFF), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E55A7), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2E55A7) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF2E55A7), width: 2),
            ),
            child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          ),
          const SizedBox(width: 10),
          Text(
            gender,
            style: const TextStyle(color: Color(0xFF2E55A7), fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}