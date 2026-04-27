import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  String selectedRole = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EEF6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff2F4F9F),
              ),
            ),
            const SizedBox(height: 30),

            buildTextField("Name", nameController, false),
            buildTextField("Email", emailController, false),
            buildTextField("Password", passwordController, true),
            buildTextField("Confirm Password", confirmPasswordController, true),

            const SizedBox(height: 30),

            const Text(
              "CHOOSE YOUR ROLE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff2F4F9F),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // بيوزعهم بانتظام
              children: [
                Expanded(child: buildRoleItem("Doctor", "assets/doctor (1).png")),
                Expanded(child: buildRoleItem("Super Admin", "assets/super admin (1).png")),
                Expanded(child: buildRoleItem("Nurse", "assets/nurse (1).png")),
              ],
            ),

            const SizedBox(height: 40),

            // زرار الـ Sign up
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6D8FEF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // 1. التأكد من أن جميع الحقول ممتلئة
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields!")),
                    );
                    return;
                  }

                  // 2. التأكد من صيغة الإيميل
                  if (!isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid email address (e.g., name@example.com)")),
                    );
                    return;
                  }

                  // 3. التأكد من تطابق كلمة السر
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match!")),
                    );
                    return;
                  }

                  // 4. التأكد من اختيار الـ Role
                  if (selectedRole == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a role first!")),
                    );
                    return;
                  }

                  // 5. لو كل حاجة صح، ينقله للشاشة المناسبة (أو ينادي على الـ API)
                  if (selectedRole == "Doctor") {
                    Navigator.pushNamed(context, '/doctor');
                  } else if (selectedRole == "Nurse") {
                    Navigator.pushNamed(context, '/nurse');
                  } else if (selectedRole == "Super Admin") {
                    Navigator.pushNamed(context, '/super_admin');
                  }
                },
                child: const Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),

            const SizedBox(height: 15),

            // زرار Already have an account
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFF719EFF), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text(
                  "Already have an account",
                  style: TextStyle(color: Color(0xff6D8FEF), fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget لإنشاء الخانات
  Widget buildTextField(String hint, TextEditingController controller, bool isPass) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        // لو الخانة إيميل، يظهر كيبورد الإيميل
        keyboardType: hint == "Email" ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff6D8FEF)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Widget لإنشاء صورة الـ Role
  Widget buildRoleItem(String roleName, String imagePath) {
    bool isSelected = selectedRole == roleName;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = roleName;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? const Color(0xff2F4F9F) : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10)] : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, width: 85, height: 85, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            roleName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xff2F4F9F) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}