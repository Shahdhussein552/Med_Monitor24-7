import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_profile.dart';
import 'create_tasks_screen.dart';
import 'doctor_custom_drawer.dart';
import '../../core/nav_painter.dart';
import '../../features/doctor/doctor_profile_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onUpdate;

  const DoctorHomeScreen({
    Key? key,
    required this.user,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late UserProfile currentUser;
  int _selectedIndex = 0; // 0 للهوم، 1 للمهام، 2 للبروفايل
  DateTime selectedDate = DateTime.now();
  List<DateTime> days = List.generate(14, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  void _updateUser(UserProfile newUser) {
    setState(() {
      currentUser = newUser;
    });
    widget.onUpdate(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFE9EEF6),
      // إظهار الدراور فقط في شاشة الهوم (index 0)
      drawer: _selectedIndex == 0
          ? CustomSideDrawer(
        user: currentUser,
        onUpdate: _updateUser,
        onProfileBack: () => setState(() {}),
      )
          : null,
      bottomNavigationBar: _buildCurvedBottomNav(context),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildUnitsView();
      case 1:
      // استدعاء واجهة المهام
        return const TasksScreen();
      case 2:
        return DoctorProfileScreen(
          user: currentUser,
          onUpdate: _updateUser,
        );
      default:
        return _buildUnitsView();
    }
  }

  // 1. واجهة الوحدات (Home View)
  Widget _buildUnitsView() {
    List<String> units = ["A", "B", "C", "D", "E", "F", "G"];
    return Column(
      children: [
        Container(
          height: 120,
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF7CA1FF),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text("Units",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildDoctorInfo(),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              itemCount: units.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) => _buildUnitCard(context, units[index]),
            ),
          ),
        ),
        _buildAddPatientButton(context),
        const SizedBox(height: 100),
      ],
    );
  }

  // 2. واجهة المهام (Tasks View)
  Widget _buildTasksView() {
    String formattedTopDate = DateFormat('MMMM d , yyyy').format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppBar مدمج كـ Container ليتناسب مع التصميم
        Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF7CA1FF),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 15),
          child: const Text("Tasks",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedTopDate, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const Text("Today",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5))),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CA1FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/add_task'),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Task", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // شريط الأيام
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: days.length,
            itemBuilder: (context, index) {
              DateTime dayDate = days[index];
              bool isSelected = dayDate.day == selectedDate.day &&
                  dayDate.month == selectedDate.month &&
                  dayDate.year == selectedDate.year;

              return GestureDetector(
                onTap: () => setState(() => selectedDate = dayDate),
                child: _buildCalendarDay(
                  DateFormat('MMM').format(dayDate),
                  dayDate.day.toString(),
                  DateFormat('E').format(dayDate).toUpperCase(),
                  isSelected: isSelected,
                ),
              );
            },
          ),
        ),
        const Spacer(),
        // صورة الـ Empty State
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                ),
                child: const CircleAvatar(
                  radius: 90,
                  backgroundColor: Color(0xFFE1F5FE),
                  backgroundImage: AssetImage("assets/no tasks (1).png"),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "No tasks for ${DateFormat('EEEE').format(selectedDate)} !",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5)),
              ),
            ],
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  // الميثود المساعدة لبناء يوم في الكاليندر
  Widget _buildCalendarDay(String month, String day, String weekday, {bool isSelected = false}) {
    return Container(
      width: 65,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B5BB5) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 5)] : [],
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(day,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(weekday, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // --- دوال الـ Nav Bar الأصلية مع تعديل بسيط للربط ---

  Widget _buildCurvedBottomNav(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double unitWidth = deviceWidth / 3;

    return Container(
      height: 85,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCirc,
            tween: Tween<double>(begin: 0, end: _selectedIndex.toDouble()),
            builder: (context, value, child) {
              return CustomPaint(
                size: Size(deviceWidth, 85),
                painter: DynamicCirclePainter(
                  xOffsetPercent: (value * unitWidth + unitWidth / 2) / deviceWidth,
                ),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCirc,
            left: (_selectedIndex * unitWidth) + (unitWidth / 2) - 28,
            top: 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF719EFF),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Icon(_getIconForIndex(_selectedIndex), color: Colors.white, size: 28),
            ),
          ),
          Positioned(
            bottom: 15,
            width: deviceWidth,
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_outlined),
                _buildNavItem(1, Icons.assignment_turned_in_outlined),
                _buildNavItem(2, Icons.person_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _selectedIndex = index),
        child: Opacity(
          opacity: _selectedIndex == index ? 0 : 1,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    if (index == 0) return Icons.home;
    if (index == 1) return Icons.assignment_turned_in;
    return Icons.person;
  }

  // --- بقية الميثودز المساعدة من كودك الأصلي ---
  Widget _buildDoctorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage("assets/doctor (1).png"),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currentUser.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5))),
              const Text("Cardiologist", style: TextStyle(fontSize: 16, color: Color(0xFF7CA1FF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(BuildContext context, String unitName) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/beds', arguments: unitName),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
          ],
          border: Border.all(color: const Color(0xFF7CA1FF).withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 15,
                left: 15,
                child: Text(unitName,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5)))),
            Center(child: Image.asset("assets/unit.png", fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPatientButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CA1FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: () => Navigator.pushNamed(context, '/addPatient',
              arguments: {'user': currentUser, 'onUpdate': _updateUser}),
          child: const Text("add patient",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}