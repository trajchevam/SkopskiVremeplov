import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skopski_vremeplov/modules/tour.dart';
import '../modules/monument.dart';

class NewTour extends StatefulWidget {
  final Function addTour;
  final List<Monument> monuments;

  const NewTour({super.key, required this.addTour, required this.monuments});

  @override
  State<NewTour> createState() => _NewTourState();
}

class _NewTourState extends State<NewTour> {

  final _nameController = TextEditingController();
  final _numberOfNeededDaysController = TextEditingController();
  int? _intValue;

  late List<Monument> _selectedMonuments;
  List<Monument> allMonuments = [];

  @override
  void initState() {
    super.initState();
    allMonuments = widget.monuments + Monument.getMonuments();
  }

  void _submitData() {
    if (_nameController.text.isEmpty || _numberOfNeededDaysController.text.isEmpty) {
      return;
    }
    final enteredName = _nameController.text;
    final enteredNeededDays = _numberOfNeededDaysController.text;

    if (enteredName.isEmpty || enteredNeededDays.isEmpty) {
      return;
    }

    final newTour = Tour(
      Random().nextInt(1000),
        enteredName,
        int.parse(enteredNeededDays),
        _selectedMonuments
    );

    widget.addTour(newTour);
    // NotificationService.sendNotification(newTour);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        const Text("Додади тура",
            style: TextStyle(fontSize: 20, color: Colors.orange)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Име на тура",
            hintText: "Скопска околина",
          ),
          onSubmitted: (_) => _submitData,
        ),
        TextField(
          controller: _numberOfNeededDaysController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Потребни денови за прошетка',
          ),
          onChanged: (value) {
            setState(() {
              _intValue = int.tryParse(value);
            });
          },
        ),
        MultiSelectDialogField(
          items: allMonuments.map((monument) => MultiSelectItem(monument, monument.name)).toList(),
          listType: MultiSelectListType.CHIP,
          buttonText: Text("Одбери знаменитости"),
          confirmText: Text("Ок"),
          cancelText: Text("Откажи"),
          onConfirm: (values) {
            _selectedMonuments = values;
          },
          checkColor: Colors.orange,
        ),
        ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.orange,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey,
              elevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: const Text("Зачувај"))
      ]),
    );
  }
}