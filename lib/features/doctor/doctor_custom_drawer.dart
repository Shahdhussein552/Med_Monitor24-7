import 'package:flutter/material.dart';
import '../../features/doctor/user_profile.dart';
import '../../features/doctor/logout_screen.dart';
import '../../features/doctor/settings_screen.dart';
import '../../features/doctor/help_screen.dart';
import '../../features/doctor/doctor_profile_screen.dart';
import '../../features/doctor//update_doctor_profile_screen.dart';


class CustomSideDrawer extends StatelessWidget {
  final UserProfile user;
  final Function(UserProfile) onUpdate;
  final VoidCallback onProfileBack;

  const CustomSideDrawer({
    super.key,
    required this.user,
    required this.onUpdate,
    required this.onProfileBack,
  });

  @override
  Widget build(BuildContext context) {
    // توحيد الألوان
    const Color itemsColor = Colors.black;
    const Color nameColor = Color(0xFF2E55A7);

    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          // Header
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF719EFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/doctor (1).png'),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: nameColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Cardiologist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // القائمة
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                // 2. تعديل الملف الشخصي
                _drawerItem(Icons.edit_note_outlined, ' Profile', itemsColor, () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => UpdateProfileScreen(user: user, onSave: onUpdate),
                    ),
                  );
                  onProfileBack();
                }),

                // 3. الإعدادات
                _drawerItem(Icons.settings_outlined, 'Settings', itemsColor, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen()));
                }),

                // 4. المساعدة
                _drawerItem(Icons.help_outline, 'Help', itemsColor, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const HelpScreen()));
                }),


                // 5. تسجيل الخروج
                _drawerItem(Icons.logout, 'Log out', itemsColor, () {
                  Navigator.pop(context);
                  LogoutDialog.show(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData ic, String t, Color color, VoidCallback onTap) => ListTile(
    leading: Icon(ic, color: color, size: 26),
    title: Text(
      t,
      style: TextStyle(
        color: color, // التأكد من استخدام اللون الأسود الممرر هنا
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}