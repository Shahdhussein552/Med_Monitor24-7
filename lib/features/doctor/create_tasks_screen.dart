import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTasksScreen extends StatefulWidget {
  const CreateTasksScreen({Key? key}) : super(key: key);

  @override
  State<CreateTasksScreen> createState() => _CreateTasksScreenState();
}

class _CreateTasksScreenState extends State<CreateTasksScreen> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> days =
  List.generate(14, (index) => DateTime.now().add(Duration(days: index)));

  @override
  Widget build(BuildContext context) {
    String formattedTopDate = DateFormat('MMMM d , yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF6),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7CA1FF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Tasks",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedTopDate,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.grey)),
                    const Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B5BB5)),
                    ),
                  ],
                ),
                // ✅ زر Add Task الصحيح — المسار مصحح
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CA1FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/addTask'), // ✅ مصحح
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Add Task",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                  onTap: () {
                    setState(() {
                      selectedDate = dayDate;
                    });
                  },
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
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 15)
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 100,
                    backgroundColor: Color(0xFFE1F5FE),
                    backgroundImage: AssetImage("assets/images/task.jpg"),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "No tasks for ${DateFormat('EEEE').format(selectedDate)} !",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B5BB5)),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
      bottomNavigationBar: _buildCurvedBottomNav(context),
    );
  }

  Widget _buildCalendarDay(String month, String day, String weekday,
      {bool isSelected = false}) {
    return Container(
      width: 65,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B5BB5) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow:
        isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 5)] : [],
        border:
        isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month,
              style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontSize: 12)),
          const SizedBox(height: 4),
          Text(day,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(weekday,
              style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCurvedBottomNav(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(deviceWidth, 80),
            painter: _StaticCirclePainter(xOffsetPercent: 0.5),
          ),
          Positioned(
            left: (deviceWidth * 0.5) - 30,
            top: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  color: Color(0xFF7CA1FF), shape: BoxShape.circle),
              child: const Icon(Icons.assignment_turned_in,
                  color: Colors.white, size: 30),
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.home_outlined,
                      color: Colors.white, size: 30),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/doctor'),
                ),
                const SizedBox(width: 60),
                IconButton(
                  icon: const Icon(Icons.person_outline,
                      color: Colors.white, size: 30),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/doctorProfile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _StaticCirclePainter extends CustomPainter {
  final double xOffsetPercent;
  _StaticCirclePainter({required this.xOffsetPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF719EFF)
      ..style = PaintingStyle.fill;

    const double r = 35;
    final double x = size.width * xOffsetPercent;

    final path = Path()
      ..moveTo(0, 20)
      ..lineTo(x - r, 20)
      ..arcToPoint(Offset(x + r, 20),
          radius: const Radius.circular(r), clockwise: false)
      ..lineTo(size.width, 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}