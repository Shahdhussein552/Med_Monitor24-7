import 'package:flutter/material.dart';
import '../doctor/user_profile.dart';
import '../../features/admin/help_screen.dart';
import '../../features/admin/edit_profile_screen.dart';
import '../../features/admin/settings_screen.dart';
import '../../features/admin/logout_screen.dart';

// تأكدي من استيراد ملف الـ LogoutDialog إذا كان في ملف منفصل
// import 'path_to_your_dialog_file/logout_dialog.dart';

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
    const Color itemsColor = Colors.black;
    const Color nameColor = Color(0xFF2E55A7);

    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          // Header: الجزء العلوي الذي يحتوي على الصورة والاسم
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
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/super admin (1).png'),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          color: nameColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items: قائمة الخيارات
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _drawerItem(Icons.person_outline, 'Profile', itemsColor, () async {
                  Navigator.pop(context); // إغلاق الـ Drawer
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => EditProfileScreen(user: user, onSave: onUpdate),
                    ),
                  );
                  onProfileBack();
                }),
                _drawerItem(Icons.settings_outlined, 'Settings', itemsColor, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen()));
                }),
                _drawerItem(Icons.help_outline, 'Help', itemsColor, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const HelpScreen()));
                }),
                _drawerItem(Icons.logout, 'Log out', itemsColor, () {
                  // أولاً بنقفل الـ Drawer
                  Navigator.pop(context);

                  // ثانياً بنادي على الـ Dialog مباشرة باستخدام الميثود اللي أنت كاتبها
                  LogoutDialog.show(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget مساعد لبناء عناصر القائمة بشكل موحد
  Widget _drawerItem(IconData ic, String t, Color color, VoidCallback onTap) => ListTile(
    leading: Icon(ic, color: color, size: 26),
    title: Text(
      t,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}