import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_profile.dart';

class UpdateNurseProfileScreen extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onSave;

  const UpdateNurseProfileScreen({super.key, required this.user, required this.onSave});

  @override
  State<UpdateNurseProfileScreen> createState() => _UpdateNurseProfileScreenState();
}

class _UpdateNurseProfileScreenState extends State<UpdateNurseProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _passController;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    // تهيئة البيانات من المستخدم الحالي
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _dobController = TextEditingController(text: widget.user.dob);
    _emailController = TextEditingController(text: widget.user.email);
    _passController = TextEditingController(text: widget.user.password);
    _selectedGender = widget.user.gender;
  }

  // دالة حفظ البيانات في ذاكرة الجهاز
  Future<void> _saveToDisk(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode({
      'name': user.name,
      'phone': user.phone,
      'dob': user.dob,
      'email': user.email,
      'password': user.password,
      'gender': user.gender,
    });
    await prefs.setString('user_profile', userJson);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF719EFF);
    const Color textColor = Color(0xFF2E55A7);

    return Scaffold(
      backgroundColor: const Color(0xFFEDF3FF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // صورة بروفايل الممرضة
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo[900],
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/nurse (1).png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.user.name,
              style: const TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // حقول الإدخال
            _buildEditField("Name", _nameController),
            const SizedBox(height: 15),
            _buildEditField("Phone", _phoneController),
            const SizedBox(height: 15),
            _buildEditField("Date of birth", _dobController, isDate: true),
            const SizedBox(height: 15),
            _buildEditField("Email", _emailController),
            const SizedBox(height: 15),
            _buildEditField("Password", _passController, isPassword: true),

            const SizedBox(height: 20),

            // اختيار الجنس
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (v) => setState(() => _selectedGender = v!),
                  activeColor: primaryBlue,
                ),
                const Text('Male', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                const SizedBox(width: 40),
                Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (v) => setState(() => _selectedGender = v!),
                  activeColor: primaryBlue,
                ),
                const Text('Female', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 30),

            // زر التحديث
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  UserProfile updatedUser = UserProfile(
                    name: _nameController.text.trim().isEmpty ? widget.user.name : _nameController.text,
                    phone: _phoneController.text.trim().isEmpty ? widget.user.phone : _phoneController.text,
                    dob: _dobController.text.trim().isEmpty ? widget.user.dob : _dobController.text,
                    email: _emailController.text.trim().isEmpty ? widget.user.email : _emailController.text,
                    password: _passController.text.trim().isEmpty ? widget.user.password : _passController.text,
                    gender: _selectedGender,
                  );

                  await _saveToDisk(updatedUser);
                  widget.onSave(updatedUser); // تحديث الأب (Home)

                  // الرجوع وإرسال الكائن الجديد لتحديث شاشة البروفايل فوراً
                  Navigator.of(context).pop(updatedUser);
                },
                child: const Text(
                  'Update Profile',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لبناء الحقول (يجب أن تكون خارج الـ build وداخل الـ State)
  Widget _buildEditField(String label, TextEditingController controller, {bool isPassword = false, bool isDate = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Color(0xFF2E55A7), fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF719EFF), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isDate ? const Icon(Icons.calendar_today_outlined, color: Colors.grey) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF719EFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E55A7), width: 2),
        ),
      ),
    );
  }
}