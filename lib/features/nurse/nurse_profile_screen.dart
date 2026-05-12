import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/user_profile.dart';
import 'update_nurse_profile_screen.dart';

class NurseProfileScreen extends StatefulWidget {
  final UserProfile user;
  final void Function(UserProfile) onUpdate;

  const NurseProfileScreen({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<NurseProfileScreen> createState() => _NurseProfileScreenState();
}

class _NurseProfileScreenState extends State<NurseProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // بناء القائمة بناءً على أحدث بيانات
    final List<ProfileFieldData> profileFields = [
      ProfileFieldData(label: 'Email', value: widget.user.email),
      ProfileFieldData(label: 'Password', value: '•' * widget.user.password.length),
      ProfileFieldData(label: 'Date of birth', value: widget.user.dob),
      ProfileFieldData(label: 'Gender', value: widget.user.gender),
      ProfileFieldData(label: 'Phone', value: widget.user.phone)
    ];

    const Color headerColor = Color(0xFF719EFF);
    const Color mainBackgroundColor = Color(0xFFEDF3FF);

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        children: [
          // --- الجزء العلوي (Header) ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // زر التعديل
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () async {
                          final updatedUser = await Navigator.push<UserProfile>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateNurseProfileScreen(
                                user: widget.user,
                                onSave: (newUser) {
                                  widget.onUpdate(newUser);
                                },
                              ),
                            ),
                          );

                          if (updatedUser != null) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // صورة الممرضة
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      image: const DecorationImage(
                        image: AssetImage('assets/nurse (1).png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),

          // --- قائمة البيانات الشخصية ---
          Expanded(
            child: ListView.builder(
              // تم زيادة الـ padding السفلي إلى 110 لترك مساحة كافية للـ Curved Nav Bar
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 110),
              physics: const BouncingScrollPhysics(),
              itemCount: profileFields.length,
              itemBuilder: (context, index) => _buildProfileItem(profileFields[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت عرض الحقل
  Widget _buildProfileItem(ProfileFieldData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDDE7F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.label,
            style: const TextStyle(
              color: Color(0xFF2E55A7),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data.value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF626262),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}