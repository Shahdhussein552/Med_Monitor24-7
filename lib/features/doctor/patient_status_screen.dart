import 'package:flutter/material.dart';

class PatientStatusScreen extends StatelessWidget {
  final String status; // لاستقبال الحالة (مثل pending أو stable)

  const PatientStatusScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // الألوان بناءً على التصميم في الصورة
    const Color primaryBlue = Color(0xFF719BFF);
    const Color backgroundBlue = Color(0xFFF4F7FF);

    return Scaffold(
      backgroundColor: backgroundBlue,
      body: Column(
        children: [
          // الشريط العلوي المنحني (Custom AppBar)
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: const SafeArea(
              child: Center(
                child: Text(
                  "Request status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // تصميم الأيقونة الدائرية كما في الصورة
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hourglass_empty,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // نص الحالة
                Text(
                  status, // سيعرض "pending" كما تم تمريره
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                // زر للعودة (اختياري لكن مفيد للتنقل)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(color: primaryBlue, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}