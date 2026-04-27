import 'package:flutter/material.dart';
import '../../core/nav_painter.dart';
import '../doctor/user_profile.dart';
import 'nurse_custom_drawer.dart';
import 'nurse_profile_screen.dart';
import 'nurse_tasks_screen.dart';

class NurseHomeScreen extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onUpdate;

  const NurseHomeScreen({
    Key? key,
    required this.user,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<NurseHomeScreen> createState() => _NurseHomeScreenState();
}

class _NurseHomeScreenState extends State<NurseHomeScreen> {
  int _selectedIndex = 0;

  void _handleUserUpdate(UserProfile newUser) {
    widget.onUpdate(newUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFE9EEF6),
      drawer: _selectedIndex == 0
          ? CustomSideDrawer(
        user: widget.user,
        onUpdate: _handleUserUpdate,
        onProfileBack: () => setState(() {}),
      )
          : null,
      bottomNavigationBar: _buildCurvedBottomNav(context),
      body: _buildBodyContent(context),
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildUnitsView(context);
      case 1:
        return const NurseTaskScreen(true);
      case 2:
        return NurseProfileScreen(
          user: widget.user,
          onUpdate: _handleUserUpdate,
        );
      default:
        return _buildUnitsView(context);
    }
  }

  Widget _buildUnitsView(BuildContext context) {
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
                child: Text(
                  "Units",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildNurseInfo(),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              itemCount: units.length,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 110,
                top: 10,
              ),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) =>
                  _buildUnitCard(context, units[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNurseInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage("assets/nurse (1).png"),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5BB5),
                ),
              ),
              const Text(
                "ICU Specialist",
                style: TextStyle(fontSize: 16, color: Color(0xFF7CA1FF)),
              ),
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
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
          border: Border.all(
            color: const Color(0xFF7CA1FF).withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: Text(
                unitName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5BB5),
                ),
              ),
            ),
            Center(
              child: Image.asset("assets/unit.png", fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

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
            tween: Tween<double>(
              begin: 0,
              end: _selectedIndex.toDouble(),
            ),
            builder: (context, value, child) {
              return CustomPaint(
                size: Size(deviceWidth, 85),
                painter: DynamicCirclePainter(
                  xOffsetPercent:
                  (value * unitWidth + unitWidth / 2) / deviceWidth,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Icon(
                _getIconForIndex(_selectedIndex),
                color: Colors.white,
                size: 28,
              ),
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
}