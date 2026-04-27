import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppColors {
  static const Color primaryBlue = Color(0xFF7CA1FF);
  static const Color darkBlue = Color(0xFF2C56B3);
  static const Color scaffoldBg = Color(0xFFE9EEF6);
  static const Color cardBg = Color(0xFF2C56B3);
}

class NurseTaskScreen extends StatefulWidget {
  final bool isDoctor;
  final Map<String, String>? newTask;

  const NurseTaskScreen(
      this.isDoctor, {
        Key? key,
        this.newTask,
      }) : super(key: key);

  @override
  State<NurseTaskScreen> createState() => _NurseTaskScreenState();
}

class _NurseTaskScreenState extends State<NurseTaskScreen> {
  bool hasTasks = false;
  DateTime selectedDate = DateTime.now();
  late List<DateTime> days;
  List<Map<String, String>> tasks = [];

  @override
  void initState() {
    super.initState();
    _generateDays();

    _loadTasks().then((_) {
      if (widget.newTask != null) {
        setState(() {
          tasks.add(widget.newTask!);
          hasTasks = true;
        });
        _saveTasks();
      }
    });
  }

  void _generateDays() {
    days = List.generate(
      14,
          (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);

      setState(() {
        tasks = decoded.map((e) => Map<String, String>.from(e)).toList();
        hasTasks = tasks.isNotEmpty;
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(tasks));
  }

  Future<void> _deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
      hasTasks = tasks.isNotEmpty;
    });
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTopDate = DateFormat('MMMM d, yyyy').format(selectedDate);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      // تأكدي إن مفيش floatingActionButton هنا نهائياً
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الـ Header الأزرق العلوي
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const SafeArea(
              bottom: false,
              child: Center(
                child: Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // منطقة عرض التاريخ والتقويم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedTopDate,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // شريط الأيام الأفقي
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

          const SizedBox(height: 20),

          // قائمة المهام
          Expanded(
            child: hasTasks ? _buildTasksList() : _buildEmptyState(),
          ),
        ],
      ),
      // تم حذف bottomNavigationBar تماماً من هنا
    );
  }

  Widget _buildCalendarDay(String month, String day, String weekday, {bool isSelected = false}) {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
          Text(day, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(weekday, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IntrinsicHeight( // عشان الـ VerticalDivider يشتغل صح
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task['name'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          Text('${task['startTime']} to ${task['endTime']}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(task['note'] ?? "", style: const TextStyle(color: Colors.white70, fontSize: 15)),
                    ],
                  ),
                ),
                const VerticalDivider(color: Colors.white38, thickness: 1, indent: 5, endIndent: 5),
                const SizedBox(width: 10),
                RotatedBox(
                  quarterTurns: 3,
                  child: const Text("To Do", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                if (widget.isDoctor)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70),
                    onPressed: () => _deleteTask(index),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        widget.isDoctor ? "No tasks for today!" : "No tasks assigned.",
        style: const TextStyle(color: AppColors.darkBlue, fontSize: 16),
      ),
    );
  }
}