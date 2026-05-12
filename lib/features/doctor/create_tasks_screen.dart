import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_task_screen.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF7CA1FF);
  static const Color darkBlue = Color(0xFF3B5BB5);
  static const Color scaffoldBg = Color(0xFFE9EEF6);
  static const Color cardBg = Color(0xFF3B5BB5);
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> days;
  List<Map<String, String>> tasks = [];
  String userRole = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateDays();
    _loadInitialData();
  }

  void _generateDays() {
    days = List.generate(14, (index) => DateTime.now().add(Duration(days: index)));
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? "doctor";
    });

    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      setState(() {
        tasks = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
    setState(() => isLoading = false);
  }

  // دالة الحفظ في التخزين المحلي
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(tasks));
  }

  // دالة إظهار مربع التأكيد والحذف
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // إغلاق المربع دون حذف
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  tasks.removeAt(index); // حذف المهمة من القائمة
                });
                await _saveTasks(); // حفظ القائمة الجديدة في التخزين
                Navigator.pop(context); // إغلاق المربع
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedTopDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Tasks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedTopDate,
                          style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.none),
                        ),
                        const Text(
                          "Today",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                              decoration: TextDecoration.none
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userRole == "doctor")
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                        );
                        _loadInitialData();
                      },
                      icon: const Icon(Icons.add, color: Colors.white, size: 18),
                      label: const Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 13)),
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
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty ? _buildEmptyState() : _buildTasksList(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDay(String month, String day, String weekday, {bool isSelected = false}) {
    return Container(
      width: 65,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12, decoration: TextDecoration.none)),
          Text(day, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
          Text(weekday, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12, decoration: TextDecoration.none)),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['name'] ?? "No Name",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white70, size: 16),
                        const SizedBox(width: 5),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${task['startTime']} - ${task['endTime']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 14, decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // تعديل هنا: إضافة GestureDetector أو IconButton لتشغيل الحذف
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
                onPressed: () => _showDeleteDialog(index), // استدعاء مربع الحذف
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage("assets/no tasks (1).png")
          ),
          const SizedBox(height: 20),
          Text(
            "No tasks for Today!",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlue, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}