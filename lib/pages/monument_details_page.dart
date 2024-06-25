import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skopski_vremeplov/modules/monument.dart';
import 'package:skopski_vremeplov/pages/exam%20files/calendar.dart';
import 'package:skopski_vremeplov/pages/login_register_page.dart';
import 'package:skopski_vremeplov/pages/google_maps_page.dart';
import 'package:skopski_vremeplov/pages/monuments_page.dart';
import 'package:skopski_vremeplov/pages/new_monument_page.dart';
import 'package:skopski_vremeplov/pages/new_tour_page.dart';
import 'package:skopski_vremeplov/pages/sign_out_page.dart';
import 'package:skopski_vremeplov/pages/tours_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

import '../modules/location.dart';
import '../modules/tour.dart';
import 'new_location_page.dart';

class MonumentDetailsPage extends StatefulWidget {
  const MonumentDetailsPage(
      {super.key,
      required this.locations,
      required this.monuments,
      required this.tours,
      required this.monumentId});

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;
  final int monumentId;

  @override
  State<MonumentDetailsPage> createState() => _MonumentDetailsPageState();
}

class _MonumentDetailsPageState extends State<MonumentDetailsPage> {
  List<Tour> _tours = [];
  List<Monument> _monuments = [];
  List<Location> _locations = [];
  var _monumentId;

  File? _selectedImage;

  String? errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tours = widget.tours;
    _monuments = widget.monuments;
    _locations = widget.locations;
    _monumentId = widget.monumentId;
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MonumentDetailsPage(
                      locations: _locations,
                      monuments: _monuments,
                      tours: _tours,
                      monumentId: _monumentId,
                    )));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isSignedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.orange, actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MonumentsPage(
                            locations: _locations,
                            monuments: _monuments,
                            tours: _tours,
                          )));
            },
            icon: const Icon(Icons.arrow_circle_left),
            iconSize: 30,
            color: Colors.white,
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GoogleMaps([_monuments[_monumentId]])));
            },
            icon: const Icon(Icons.location_on),
            iconSize: 30,
            color: Colors.white,
          ),
          if (isSignedIn) ...[
            ElevatedButton(
              onPressed: _signOut,
              child: const Text(
                "Одјави се",
                style: TextStyle(color: Colors.orange),
              ),
            )
          ] else ...[
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                            locations: _locations,
                            monuments: _monuments,
                            tours: _tours)));
              },
              child: const Text(
                "Најави се",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ]
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _monuments[_monumentId].name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8.0), // Adding SizedBox for spacing
                Text(
                  _monuments[_monumentId].description,
                  style: TextStyle(fontSize: 16.0, color: Colors.brown),
                ),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.center, // Center align the content
                  child: Container(
                    width: 300, // Adjust width as needed
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.orange, width: 4.0), // Border styling
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        _selectedImage != null
                            ? Image.file(_selectedImage!)
                            : Container(),
                        _selectedImage != null
                            ? Container(
                                color: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  _monuments[_monumentId].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _takePhotoFromCamera();
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                    iconSize: 30,
                                    color: Colors.orange,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _pickImageFromGallery();
                                    },
                                    icon: const Icon(Icons.photo),
                                    iconSize: 30,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _takePhotoFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
