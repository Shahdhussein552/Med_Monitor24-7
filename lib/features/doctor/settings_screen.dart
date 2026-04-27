import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // حالات المفاتيح (Toggles) - تقدري تغيري القيم الافتراضية هنا
  bool _enableNotifications = false;
  bool _heartRateAlert = false;
  bool _oxygenLevelAlert = true; // دي اللي متفعلة في الصورة
  bool _taskDelayAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF6),

      /// --- AppBar ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF7CA1FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // قائمة الإعدادات
            _buildSettingItem(
              title: "Enable Notifications",
              value: _enableNotifications,
              onChanged: (val) => setState(() => _enableNotifications = val),
            ),
            const Divider(thickness: 1.5, color: Colors.grey),

            _buildSettingItem(
              title: "Heart Rate Alert",
              value: _heartRateAlert,
              onChanged: (val) => setState(() => _heartRateAlert = val),
            ),

            _buildSettingItem(
              title: "Oxygen Level Alert",
              value: _oxygenLevelAlert,
              onChanged: (val) => setState(() => _oxygenLevelAlert = val),
            ),

            _buildSettingItem(
              title: "Task Delay Alert",
              value: _taskDelayAlert,
              onChanged: (val) => setState(() => _taskDelayAlert = val),
            ),
          ],
        ),
      ),
    );
  }

  /// ويدجت لبناء سطر الإعدادات بشكل متناسق
  Widget _buildSettingItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B5BB5), // اللون الأزرق الغامق الموحد
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7CA1FF), // لون التفعيل
            activeTrackColor: const Color(0xFF7CA1FF).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}