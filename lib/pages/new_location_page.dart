import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skopski_vremeplov/pages/monuments_page.dart';
import '../modules/location.dart';
import '../modules/monument.dart';
import '../modules/tour.dart';

class NewLocation extends StatefulWidget {
  final Function addLocation;

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;

  const NewLocation({super.key, required this.addLocation, required this.locations, required this.monuments, required this.tours});

  @override
  State<NewLocation> createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> {

  final _nameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  late List<Monument> _selectedMonuments;

  List<Tour> _tours = [];
  List<Monument> _monuments = [];
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _tours = widget.tours;
    _monuments = widget.monuments;
    _locations = widget.locations;
  }

  void _submitData() {
    if (_nameController.text.isEmpty || _latitudeController.text.isEmpty) {
      return;
    }
    final enteredName = _nameController.text;
    final enteredLatitude = _latitudeController.text;
    final enteredLongitude = _longitudeController.text;

    if (enteredName.isEmpty || enteredLatitude.isEmpty || enteredLongitude.isEmpty) {
      return;
    }

    final newLocation = Location(
        locationName: enteredName,
        latitude: double.parse(enteredLatitude),
        longitude: double.parse(enteredLongitude)
    );

    widget.addLocation(newLocation);
    _locations.add(newLocation);
    // NotificationService.sendNotification(newLocation);
    // Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MonumentsPage(
              locations: _locations,
              monuments: _monuments,
              tours: _tours,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        const Text("Додади локација",
            style: TextStyle(fontSize: 20, color: Colors.orange)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Име на локација",
            hintText: "Мајка тереза",
          ),
          onSubmitted: (_) => _submitData,
        ),
        TextField(
          controller: _longitudeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Географска должина',
          ),
          onChanged: (value) {
            setState(() {
              double.tryParse(value);
            });
          },
        ),
        TextField(
          controller: _latitudeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Географска ширина',
          ),
          onChanged: (value) {
            setState(() {
              double.tryParse(value);
            });
          },
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