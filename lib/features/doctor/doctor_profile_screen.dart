import 'package:flutter/material.dart';
import '../../features/doctor/app_models.dart'; // تأكد من المسار الصحيح
import '../../features/doctor/user_profile.dart';
import '../../features/doctor/update_doctor_profile_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final UserProfile user;
  final void Function(UserProfile) onUpdate;

  const DoctorProfileScreen({
    Key? key,
    required this.user,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // تعريف القائمة مع التأكد من نوع البيانات
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen(
                                  user: widget.user,
                                  onSave: (updatedUser) {
                                    widget.onUpdate(updatedUser);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: const DecorationImage(
                          image: AssetImage('assets/doctor (1).png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.user.name,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: profileFields.length,
              itemBuilder: (context, index) => _buildProfileItem(profileFields[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(ProfileFieldData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDDE7F5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data.label, style: const TextStyle(color: Color(0xFF2E55A7), fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(data.value, textAlign: TextAlign.end, style: const TextStyle(color: Color(0xFF626262), fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}