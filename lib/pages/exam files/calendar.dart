import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../modules/exam.dart';
import '../tours_page.dart';

class CalendarPage extends StatefulWidget {
  static const String id = "calendarPage";
  final List<Exam> exams;

  const CalendarPage({super.key, required this.exams});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Exam>> _events;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<Exam> _selectedExams;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay =
        DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    _events = {};

    _selectedExams = [];

    for (var exam in widget.exams) {
      final date = DateTime(exam.date.year, exam.date.month, exam.date.day);
      if (_events[date] == null) _events[date] = [];
      _events[date]!.add(exam);
    }

    _selectedExams = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('Activity Calendar',  style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ToursPage(locations: [],monuments: [], tours: [],))
                );
              })
        ],
      ),
      body: Column(
        children: [
          Text("Exams for "+ _focusedDay.toString().split(" ")[0]),
          TableCalendar(
            headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 1, 1),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                _focusedDay = focusedDay;
                _selectedExams = _events[_selectedDay] ?? [];
              });
            },
            eventLoader: (day) => _events[day] ?? [],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedExams.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.pinkAccent
                    ),
                  child: ListTile(
                    title: Text(_selectedExams[index].subject, style: TextStyle(color: Colors.white),),
                    subtitle:
                    Text(_selectedExams[index].date.toString().split(" ")[0]+" at " +_selectedExams[index].date.toString().split(" ")[1].split(".")[0],  style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}