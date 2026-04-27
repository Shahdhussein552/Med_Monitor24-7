import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_task_screen.dart'; // تأكد من صحة المسار

class AppColors {
  static const Color primaryBlue = Color(0xFF7CA1FF);
  static const Color darkBlue = Color(0xFF3B5BB5);
  static const Color scaffoldBg = Color(0xFFE9EEF6);
  static const Color cardBg = Color(0xFF3B5BB5);
}

class TasksScreen extends StatefulWidget {
  final Map<String, String>? newTask;
  const TasksScreen({Key? key, this.newTask}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showCreatedTask = false;
  DateTime selectedDate = DateTime.now();
  late List<DateTime> days;
  List<Map<String, String>> tasks = [];

  // متغير لتخزين دور المستخدم
  String userRole = "";

  @override
  void initState() {
    super.initState();
    _generateDays();
    _loadInitialData();
  }

  // دالة مجمعة لتحميل البيانات عند التشغيل
  Future<void> _loadInitialData() async {
    await _getUserRole();
    await _loadTasks();

    if (widget.newTask != null) {
      setState(() {
        tasks.add(widget.newTask!);
        _showCreatedTask = true;
      });
      _saveTasks();
    }
  }

  // جلب دور المستخدم من التخزين المحلي
  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // ملحوظة: تأكد أن القيمة المخزنة في الـ Login هي 'doctor' بالظبط حروف صغيرة
      userRole = prefs.getString('role') ?? "doctor"; // غيرتها لـ doctor مؤقتاً عشان تظهر معاك فوراً
    });
  }

  void _generateDays() {
    days = List.generate(14, (index) => DateTime.now().add(Duration(days: index)));
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      setState(() {
        tasks = decoded.map((e) => Map<String, String>.from(e)).toList();
        if (tasks.isNotEmpty) _showCreatedTask = true;
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(tasks));
  }

  // دالة الحذف الأساسية
  Future<void> _deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
      if (tasks.isEmpty) _showCreatedTask = false;
    });
    await _saveTasks();
  }

  // دالة إظهار رسالة التأكيد
  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask(index);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedTopDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tasks",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                    Text(formattedTopDate, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const Text("Today",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
                  ],
                ),
                // زر الإضافة (يظهر لو دكتور)
                if (userRole == "doctor")
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Add Task", style: TextStyle(color: Colors.white)),
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
          const SizedBox(height: 20),
          Expanded(
            child: _showCreatedTask ? _buildMyTasksList() : _buildEmptyState(),
          ),
        ],
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
                  color: isSelected ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(weekday, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMyTasksList() {
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['name'] ?? "",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white70, size: 16),
                        const SizedBox(width: 5),
                        Text('${task['startTime']} - ${task['endTime']}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(task['note'] ?? "",
                        style: const TextStyle(color: Colors.white60, fontSize: 13, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),

              // السلة - لو مش ظاهرة يبقى الـ userRole مش بـ doctor
              if (userRole == "doctor")
                IconButton(
                  // غيرت اللون لأبيض صريح عشان يبان جداً
                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  onPressed: () => _showDeleteConfirmation(index),
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
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white.withOpacity(0.5),
            backgroundImage: const AssetImage("assets/images/task.jpg"),
          ),
          const SizedBox(height: 20),
          Text(
            "No tasks for ${DateFormat('EEEE').format(selectedDate)} !",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
          ),
        ],
      ),
    );
  }
}