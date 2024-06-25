import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skopski_vremeplov/services/notification_service.dart';
import '../modules/exam.dart';
import '../modules/location.dart';
import '../modules/monument.dart';

class NewMonument extends StatefulWidget {
  final Function addMonument;

  const NewMonument({super.key, required this.addMonument});

  @override
  State<NewMonument> createState() => _NewMonumentState();
}

class _NewMonumentState extends State<NewMonument> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Location location;
  int _selectedLocationIndex = 0;
  List<Location> locations = [];


  @override
  void initState() {
    super.initState();
    locations = Location.getLocations();
    location = locations.first;
  }


  void _submitData() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    final enteredName = _nameController.text;
    final enteredDescription = _descriptionController.text;

    if (enteredName.isEmpty || enteredDescription.isEmpty) {
      return;
    }

    final newMonument = Monument(
      Random().nextInt(1000),
      enteredName,
      location,
      enteredDescription,
      ""
    );

    widget.addMonument(newMonument);
    // NotificationService.sendNotification(newMonument);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        const Text("Додади знаменитост",
            style: TextStyle(fontSize: 20, color: Colors.orange)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Име",
            hintText: "Име",
          ),
          onSubmitted: (_) => _submitData,
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: "Опис",
            hintText: "Опис",
          ),
          onSubmitted: (_) => _submitData,
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
              foregroundColor: Colors.orange,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey,
              elevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: const Text("Зачувај"))
      ]),
    );
  }
}