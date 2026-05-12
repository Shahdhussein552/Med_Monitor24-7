import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'warning_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "09:00 PM";

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  Color _selectedColor = const Color(0xFF3B5BB5);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _nurseController = TextEditingController();
  final TextEditingController _patientController = TextEditingController();

  // --- دالة فحص التعارض ---
  Future<bool> _hasTimeConflict(String newStartTime) async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      List<dynamic> decoded = jsonDecode(tasksJson);
      for (var task in decoded) {
        if (task['startTime'] == newStartTime) {
          return true; // يوجد تعارض
        }
      }
    }
    return false; // لا يوجد تعارض
  }

  // --- دالة حفظ التاسك الجديدة في SharedPreferences ---
  Future<void> _saveTaskLocally(Map<String, String> newTask) async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    List<dynamic> tasksList = [];

    if (tasksJson != null) {
      tasksList = jsonDecode(tasksJson);
    }

    tasksList.add(newTask);
    await prefs.setString('tasks', jsonEncode(tasksList));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF7CA1FF);
    const Color textBlue = Color(0xFF3B5BB5);

    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textBlue, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Tasks",
          style: TextStyle(color: textBlue, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Title", "Enter title here", controller: _titleController),
            _buildInputField("Note", "Enter note here", controller: _noteController),

            _buildInputField(
              "Date",
              DateFormat.yMd().format(_selectedDate),
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () => _getDateFromUser(),
            ),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    "Start time",
                    _startTime,
                    suffixIcon: Icons.access_time,
                    onTap: () => _getTimeFromUser(isStartTime: true),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInputField(
                    "End time",
                    _endTime,
                    suffixIcon: Icons.access_time,
                    onTap: () => _getTimeFromUser(isStartTime: false),
                  ),
                ),
              ],
            ),

            _buildInputField(
              "Remind",
              "$_selectedRemind minutes early",
              widget: DropdownButton<String>(
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff2E55A7)),
                iconSize: 32,
                elevation: 4,
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                items: remindList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),

            _buildInputField(
              "Repeat",
              _selectedRepeat,
              widget: DropdownButton<String>(
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff2E55A7)),
                iconSize: 32,
                elevation: 4,
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
                items: repeatList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.grey)),
                  );
                }).toList(),
              ),
            ),

            _buildInputField("Nurse Name", "Enter nurse name", controller: _nurseController),
            _buildInputField("Patient Name", "Enter patient name", controller: _patientController),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Color",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textBlue),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _colorOption(const Color(0xFF3B5BB5)),
                        _colorOption(const Color(0xFF7CA1FF)),
                        _colorOption(Colors.grey),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      if (_titleController.text.isNotEmpty) {
                        bool conflict = await _hasTimeConflict(_startTime);

                        if (conflict) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TimeConflictScreen()),
                          );
                        } else {
                          // تجميع البيانات
                          Map<String, String> newTask = {
                            "name": _titleController.text,
                            "note": _noteController.text.isEmpty ? "No Note" : _noteController.text,
                            "startTime": _startTime,
                            "endTime": _endTime,
                            "status": "Todo",
                            "nurse": _nurseController.text,
                            "patient": _patientController.text,
                          };

                          // 1. حفظ في الذاكرة
                          await _saveTaskLocally(newTask);

                          // 2. الرجوع فقط للشاشة السابقة (ستقوم هي بتحديث نفسها)
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Title is required!")),
                        );
                      }
                    },
                    child: const Text(
                      "Create task",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  Widget _buildInputField(String label, String hint, {
    TextEditingController? controller,
    IconData? suffixIcon,
    VoidCallback? onTap,
    Widget? widget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF7CA1FF)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: onTap != null || widget != null,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                widget ?? (suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF2E55A7)) : Container()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: _selectedColor == color
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      ),
    );
  }
}