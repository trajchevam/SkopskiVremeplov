import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

import '../modules/location.dart';
import '../modules/tour.dart';
import 'new_location_page.dart';

class MonumentDetailsPage extends StatefulWidget {
  const MonumentDetailsPage({
    super.key,
    required this.locations,
    required this.monuments,
    required this.tours,
    required this.monumentId
  });

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
        appBar: AppBar(
            backgroundColor: Colors.orange,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MonumentsPage(locations: _locations,monuments: _monuments, tours: _tours,)));
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
                          builder: (context) => GoogleMaps([_monuments[_monumentId]])));
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _monuments[_monumentId].name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                _monuments[_monumentId].description,
                style: TextStyle(fontSize: 16.0, color: Colors.brown),
              ),
            ],
          ),
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(
        //     _monuments[_monumentId].name,
        //     style: TextStyle(
        //       fontSize: 15,
        //       fontWeight: FontWeight.w600,
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        //     Text(
        //       _monuments[_monumentId].description,
        //       style: TextStyle(
        //         fontSize: 13,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ]),
    );
  }
}
