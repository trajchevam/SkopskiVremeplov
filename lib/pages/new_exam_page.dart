import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skopski_vremeplov/services/notification_service.dart';
import '../modules/exam.dart';
import '../modules/location.dart';

class NewExam extends StatefulWidget {
  final Function addExam;

  const NewExam({super.key, required this.addExam});

  @override
  State<NewExam> createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {

  final _subjectController = TextEditingController();
  DateTime? _examDate;

  late Location location;
  int _selectedLocationIndex = 0;
  List<Location> locations = [];


  @override
  void initState() {
    super.initState();
    locations = Location.getLocations();
    location = locations.first;
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      _presentTimePicker(pickedDate);
    });
  }

  void _presentTimePicker(DateTime pickedDate) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) return;
      setState(() {
        _examDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    });
  }

  void _submitData() {
    if (_subjectController.text.isEmpty) {
      return;
    }
    final enteredSubject = _subjectController.text;

    if (enteredSubject.isEmpty) {
      return;
    }

    final newExam = Exam(
      Random().nextInt(1000),
      enteredSubject,
      _examDate!,
      location
    );

    widget.addExam(newExam);
    NotificationService.sendNotification(newExam);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        const Text("Add new exam",
            style: TextStyle(fontSize: 20, color: Colors.purple)),
        TextField(
          controller: _subjectController,
          decoration: const InputDecoration(
            labelText: "Subject",
            hintText: "Subject",
          ),
          onSubmitted: (_) => _submitData,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (_examDate == null)
              const Text(
                'Select time and date',
              ),
            if (_examDate != null)
              Expanded(
                child: Text(
                  'Selected: ${_examDate!.toLocal()}'.split('.')[0],
                ),
              ),
            TextButton(
              onPressed: _presentDatePicker,
              child: const Icon(Icons.date_range_outlined),
            ),
          ],
        ),
        DropdownButton<int>(
          value: _selectedLocationIndex,
          onChanged: (int? newValue) {
            setState(() {
              _selectedLocationIndex = newValue ?? 0;
              location = locations[_selectedLocationIndex];
            });
          },
          items: locations.asMap().entries.map<DropdownMenuItem<int>>((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value.locationName),
            );
          }).toList(),
        ),
        ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.purple,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey,
              elevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: const Text("Submit"))
      ]),
    );
  }
}