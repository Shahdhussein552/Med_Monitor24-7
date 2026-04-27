import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DayItem { final int day; final String weekday; final String month; const DayItem({required this.day, required this.weekday, required this.month}); }
class VitalCell { final String time; final int value; const VitalCell({required this.time, required this.value}); }
class VitalRowData { final String label; final List<VitalCell> cells; const VitalRowData({required this.label, required this.cells}); }

class VitalSignsScreen extends StatefulWidget {
  const VitalSignsScreen({super.key});
  @override State<VitalSignsScreen> createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  int _selectedDay = 1;
  List<VitalRowData> _currentRows = [];
  static const Color _primaryThemeBlue = Color(0xFF719EFF);
  static const Color _accentDarkBlue = Color(0xFF2E55A7);
  static const Color _bgColor = Color(0xFFEDF3FF);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _selectedDay = DateTime.now().day; // ✅ اليوم الحالي selected تلقائي
  }

  void _loadInitialData() {
    _currentRows = [
      _createSampleRow('Heart', 75),
      _createSampleRow('Beat', 72),
      _createSampleRow('Pressure', 120),
      _createSampleRow('Oxygen', 98),
      _createSampleRow('Diabetes', 110)
    ];
  }

  VitalRowData _createSampleRow(String label, int baseValue) {
    List<VitalCell> cells = [];
    for (int i = 1; i <= 24; i++) {
      String period;
      int hour;
      if (i < 12) { hour = i; period = 'AM'; }
      else if (i == 12) { hour = 12; period = 'PM'; }
      else if (i < 24) { hour = i - 12; period = 'PM'; }
      else { hour = 12; period = 'AM'; }
      cells.add(VitalCell(time: '$hour $period', value: baseValue + Random().nextInt(10)));
    }
    return VitalRowData(label: label, cells: cells);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(children: [
        _buildHeader(context), const SizedBox(height: 8), _buildWeekStrip(), const SizedBox(height: 8),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: _currentRows.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildVitalRow(_currentRows[index])))),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 22, bottom: 12), decoration: const BoxDecoration(color: _primaryThemeBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))), child: SafeArea(child: Row(children: [ IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22), onPressed: () => Navigator.pop(context)), const Expanded(child: Text('Vital sign', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold))), const SizedBox(width: 48) ])));
  }

  Widget _buildWeekStrip() {
    // ✅ dynamic
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthName = DateFormat('MMM').format(now);
    final days = List.generate(daysInMonth, (index) {
      final date = DateTime(now.year, now.month, index + 1);
      return DayItem(
        day: date.day,
        weekday: DateFormat('EEE').format(date).toUpperCase(),
        month: monthName,
      );
    });

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final d = days[index];
          final isSelected = d.day == _selectedDay;
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = d.day),
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? _accentDarkBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(d.month, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black87)),
                  Text('${d.day}', style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                  Text(d.weekday, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black87)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVitalRow(VitalRowData row) {
    return Row(children: [
      Container(width: 70, height: 85, decoration: BoxDecoration(color: _accentDarkBlue, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(row.label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
      const SizedBox(width: 6),
      Expanded(child: SizedBox(height: 85, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: row.cells.length, separatorBuilder: (_, __) => const SizedBox(width: 6), itemBuilder: (context, index) => _buildCell(row.cells[index]))))
    ]);
  }

  Widget _buildCell(VitalCell cell) {
    return Container(width: 52, decoration: BoxDecoration(color: _primaryThemeBlue, borderRadius: BorderRadius.circular(10)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ Text(cell.time, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)), Container(height: 1.5, width: 30, color: Colors.white), Text('${cell.value}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)) ]));
  }
}