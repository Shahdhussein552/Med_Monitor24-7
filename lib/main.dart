import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// --- Providers ---
import 'features/nurse/nurse_tasks_screen.dart';
import 'providers/auth_provider.dart';
import 'package:med_monitor/providers/notification_provider.dart';

// --- Models ---
import 'features/doctor/user_profile.dart';
import 'features/doctor/patient_model.dart';
import 'features/doctor/app_models.dart';

// --- Screens: Splash & Welcome ---
import 'features/splash/splash_screen.dart';
import 'features/welcome/welcome1_screen.dart';
import 'features/welcome/welcome2_screen.dart';
import 'features/welcome/welcome3_screen.dart';

// --- Screens: Auth ---
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/forgot_password/forgot_password_email_screen.dart';
import 'features/auth/forgot_password/otp_verification_screen.dart';
import 'features/auth/forgot_password/reset_password_screen.dart';
import 'features/auth/forgot_password/update_password.dart';

// --- Screens: Doctor Features ---
import 'features/doctor/doctor_home_screen.dart';
import 'features/doctor/beds_screen.dart';
import 'features/doctor/help_screen.dart';
import 'features/doctor/settings_screen.dart';
import 'features/doctor/add_patient_screen.dart';
import 'features/doctor/patient_status_screen.dart';
import 'features/doctor/create_tasks_screen.dart';
import 'features/doctor/add_task_screen.dart';
import 'features/doctor/update_doctor_profile_screen.dart';
import 'features/doctor/doctor_profile_screen.dart';
import 'features/doctor/patient_details_screen.dart';

// --- Screens: Nurse Features ---
import 'package:med_monitor/features/nurse/nurse_home_screen.dart';
import 'package:med_monitor/features/nurse/nurse_profile_screen.dart';
import 'package:med_monitor/features/nurse/beds.dart' as nurse_beds;
import 'package:med_monitor/features/nurse/settings_screen.dart' as nurse_settings;
import 'package:med_monitor/features/nurse/help_screen.dart' as nurse_help;
import 'package:med_monitor/features/nurse/nurse_patient_details_screen.dart' as nurse_patient_details;
import 'package:med_monitor/features/nurse/nurse_tasks_screen.dart' as nurse_tasks_screen;
// --- Screens: Admin / Super Admin Features ---
import 'features/admin/super_admin_screen.dart';
import 'features/admin/pending_admission_screen.dart';
import 'features/admin/profile_screen.dart' as admin_profile;
import 'features/admin/edit_profile_screen.dart' as admin_edit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedMonitorApp());
}

class MedMonitorApp extends StatefulWidget {
  const MedMonitorApp({super.key});

  @override
  State<MedMonitorApp> createState() => _MedMonitorAppState();
}

class _MedMonitorAppState extends State<MedMonitorApp> {
  UserProfile doctorUser = UserProfile(
    name: "Dr. Magdy Osama",
    phone: "01000000001",
    dob: "January 1, 1980",
    email: "doctor@medmonitor.com",
    password: "doctorPassword",
    gender: "Male",
  );

  UserProfile nurseUser = UserProfile(
    name: "Nurse/Mary",
    phone: "01000000002",
    dob: "February 2, 1990",
    email: "nurse@medmonitor.com",
    password: "nursePassword",
    gender: "Female",
  );

  UserProfile adminUser = UserProfile(
    name: "super admin",
    phone: "01000000000",
    dob: "March 3, 1985",
    email: "admin@medmonitor.com",
    password: "adminPassword",
    gender: "Male",
  );

  final List<AdmissionRequest> mockRequests = [
    AdmissionRequest(
      doctorName: 'Dr. Magdy Osama',
      timeSent: '10 min ago',
      patientName: 'Ahmed Mohamed',
      id: "123456",
      age: "25",
      phone: "01023456789",
      gender: "Male",
      height: "180",
      weight: "75",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorUser = _getUserFromPrefs(prefs, 'doctor_profile', doctorUser);
      nurseUser  = _getUserFromPrefs(prefs, 'nurse_profile',  nurseUser);
      adminUser  = _getUserFromPrefs(prefs, 'admin_profile',  adminUser);
    });
  }

  UserProfile _getUserFromPrefs(
      SharedPreferences prefs,
      String key,
      UserProfile defaultValue,
      ) {
    final String? userJson = prefs.getString(key);
    if (userJson != null) {
      try {
        final Map<String, dynamic> map = jsonDecode(userJson);
        return UserProfile(
          name:     map['name']     ?? defaultValue.name,
          phone:    map['phone']    ?? defaultValue.phone,
          dob:      map['dob']      ?? defaultValue.dob,
          email:    map['email']    ?? defaultValue.email,
          password: map['password'] ?? defaultValue.password,
          gender:   map['gender']   ?? defaultValue.gender,
        );
      } catch (_) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  void updateDoctorInfo(UserProfile newUser) {
    setState(() => doctorUser = newUser);
    _saveToDisk('doctor_profile', newUser);
  }

  void updateNurseInfo(UserProfile newUser) {
    setState(() => nurseUser = newUser);
    _saveToDisk('nurse_profile', newUser);
  }

  void updateAdminInfo(UserProfile newUser) {
    setState(() => adminUser = newUser);
    _saveToDisk('admin_profile', newUser);
  }

  Future<void> _saveToDisk(String key, UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode({
      'name':     user.name,
      'phone':    user.phone,
      'dob':      user.dob,
      'email':    user.email,
      'password': user.password,
      'gender':   user.gender,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Med Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          primaryColor: const Color(0xFF719EFF),
          scaffoldBackgroundColor: const Color(0xFFEDF3FF),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {

          // ── Splash & Welcome ──────────────────────────────────
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashScreen());
            case '/welcome1':
              return MaterialPageRoute(builder: (_) => const Welcome1Screen());
            case '/welcome2':
              return MaterialPageRoute(builder: (_) => const Welcome2Screen());
            case '/welcome3':
              return MaterialPageRoute(builder: (_) => const Welcome3Screen());

          // ── Auth ──────────────────────────────────────────────
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());
            case '/forgot-email':
              return MaterialPageRoute(builder: (_) => const ForgotPasswordEmailScreen());
            case '/otp':
              return MaterialPageRoute(
                builder: (_) => const OtpVerificationScreen(),
                settings: settings,
              );
            case '/reset-password':
              return MaterialPageRoute(
                builder: (_) => const ResetPasswordScreen(),
                settings: settings,
              );
            case '/update-password':
              return MaterialPageRoute(builder: (_) => const UpdatePasswordScreen());

          // ── Doctor ────────────────────────────────────────────
            case '/doctor':
              return MaterialPageRoute(
                builder: (_) => DoctorHomeScreen(user: doctorUser, onUpdate: updateDoctorInfo),
              );
            case '/doctorProfile':
              return MaterialPageRoute(
                builder: (_) => DoctorProfileScreen(user: doctorUser, onUpdate: updateDoctorInfo),
              );
            case '/updateDoctorProfile':
              return MaterialPageRoute(
                builder: (_) => UpdateProfileScreen(user: doctorUser, onSave: updateDoctorInfo),
              );
            case '/addPatient':
              return MaterialPageRoute(
                builder: (_) => AddPatientScreen(user: doctorUser, onUpdate: updateDoctorInfo),
              );
          // ✅ شاشة تفاصيل المريض — بتاخد PatientData كـ argument
            case '/patientDetails':
              final patient = settings.arguments as PatientData;
              return MaterialPageRoute(
                builder: (_) => PatientDetailScreen(patient: patient),
              );
            case '/requestStatus':
              return MaterialPageRoute(builder: (_) => const RequestStatusScreen());
          // ✅ شاشة التاسكات الرئيسية للدكتور
            case '/createTasks':
              return MaterialPageRoute(builder: (_) => const CreateTasksScreen());
          // ✅ شاشة إضافة تاسك — دعم للاسمين /addTask و /add_task
            case '/add_task':
            case '/addTask':
              return MaterialPageRoute(builder: (_) => const AddTaskScreen());
            case '/beds':
              return MaterialPageRoute(builder: (_) => const BedsScreen());
            case '/settings':
              return MaterialPageRoute(builder: (_) => const SettingsScreen());
            case '/help':
              return MaterialPageRoute(builder: (_) => const HelpScreen());

          // ── Nurse ─────────────────────────────────────────────
            case '/nurse':
              return MaterialPageRoute(
                builder: (_) => NurseHomeScreen(user: nurseUser, onUpdate: updateNurseInfo),
              );
            case '/nurseProfile':
              return MaterialPageRoute(
                builder: (_) => NurseProfileScreen(user: nurseUser, onUpdate: updateNurseInfo),
              );
            case '/nurseBeds':
              return MaterialPageRoute(builder: (_) => const nurse_beds.BedsScreen());
            case '/nurseSettings':
              return MaterialPageRoute(builder: (_) => const nurse_settings.SettingsScreen());
            case '/nurseHelp':
              return MaterialPageRoute(builder: (_) => const nurse_help.HelpScreen());
          // ✅ شاشة التاسكات عند الـ Nurse — بدون زر Add Task
          // داخل MaterialApp في ملف main.dart
            case '/nurseTasks':
              return MaterialPageRoute(builder: (_) => const NurseTaskScreen(true));

          // ✅ شاشة تفاصيل المريض عند الـ Nurse — بتاخد PatientData كـ argument
            case '/nursePatientDetails':
              final patient = settings.arguments as PatientData;
              return MaterialPageRoute(
                builder: (_) => nurse_patient_details.PatientDetailScreen(patient: patient),
              );

          // ── Admin ─────────────────────────────────────────────
            case '/super_admin':
              return MaterialPageRoute(
                builder: (_) => SuperAdminScreen(user: adminUser, onUpdate: updateAdminInfo),
              );
          // ✅ دعم للاسمين المستخدمين في الكود
            case '/pending_requests':
            case '/pending_admission':
              return MaterialPageRoute(
                builder: (_) => PendingAdmissionScreen(
                  admissionRequests: mockRequests,
                  user: adminUser,
                  onUpdate: updateAdminInfo,
                ),
              );
            case '/adminProfile':
              return MaterialPageRoute(
                builder: (_) => admin_profile.ProfileScreen(
                  user: adminUser,
                  onUpdate: updateAdminInfo,
                ),
              );
            case '/adminEditProfile':
              return MaterialPageRoute(
                builder: (_) => admin_edit.EditProfileScreen(
                  user: adminUser,
                  onSave: updateAdminInfo,
                ),
              );

          // ── 404 ───────────────────────────────────────────────
            default:
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Route "${settings.name}" not found'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

// ── RequestStatusScreen ───────────────────────────────────────────────────────

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF7B9DFF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: const Text(
              'Request status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hourglass_empty,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'pending',
                  style: TextStyle(
                    color: Color(0xFF5E5E5E),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/doctor',
                        (route) => false,
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(color: Color(0xFF7B9DFF), fontSize: 18),
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