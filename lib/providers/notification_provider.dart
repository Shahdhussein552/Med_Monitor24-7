import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:med_monitor/providers/auth_provider.dart';
import 'package:med_monitor/widgets/custom_critical_alert.dart';

class NotificationProvider with ChangeNotifier {

  // دالة استقبال بيانات الـ AI وإظهار الإشعار
  void showAiAlert(BuildContext context, {
    required String patientName,
    required String unitName,
    required String alertTime,
  }) {

    // 1. هنا بنجيب الـ AuthProvider عشان نعرف الـ Role الحالية
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? userRole = authProvider.role?.toLowerCase();

    // 2. الفحص: لو المستخدم "أدمن"، مش هنعمل حاجة وهنوقف الدالة هنا
    if (userRole == "admin") {
      print("User is Admin, skipping critical alert.");
      return;
    }

    // 3. لو مش أدمن (يعني دكتور أو ممرض)، الإشعار هيظهر فوق الشاشة
    showDialog(
      context: context,
      barrierDismissible: true, // يقدر يقفله لو ضغط براه
      barrierColor: Colors.black.withOpacity(0.1), // تعتيم خفيف جداً للخلفية
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter, // عشان يظهر من فوق زي الصورة
          child: CustomCriticalAlert(
            patientName: patientName,
            unitName: unitName,
            time: alertTime, // 👈 تمرير الوقت المتغير
          ),
        );
      },
    );
  }
}