import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  String? _userName; // ضفنا الاسم عشان نحتاجه في البروفايل
  bool _isLoading = false;

  String? get token => _token;
  String? get role => _role;
  String? get userName => _userName;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // الرابط الأساسي (Base URL) - غيريه حسب سيرفر زميلك
  final String baseUrl = "http://10.0.2.2:5000/api";

  /// =============================
  /// Login (Real API)
  /// =============================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Email": email,
          "Password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // هنا بنخزن البيانات الحقيقية اللي جاية من الـ LoginResponseDto
        _token = data['token'];
        _role = data['role'];
        _userName = data['name'];

        _isLoading = false;
        notifyListeners();
        return true; // نجاح
      } else {
        _isLoading = false;
        notifyListeners();
        return false; // فشل (باسورد غلط مثلاً)
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false; // فشل (مشكلة اتصال)
    }
  }

  // ... بقية الميثودز (Register, ForgotPassword) سيبيها Mock زي ما هي
  // لحد ما زميلك يبعت الـ Controllers بتاعتها ونعدلها بنفس الطريقة.

  void logout() {
    _token = null;
    _role = null;
    _userName = null;
    notifyListeners();
  }
}