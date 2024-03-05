import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skopski_vremeplov/modules/monument.dart';
import 'package:skopski_vremeplov/pages/exam%20files/calendar.dart';
import 'package:skopski_vremeplov/pages/login_register_page.dart';
import 'package:skopski_vremeplov/pages/google_maps_page.dart';
import 'package:skopski_vremeplov/pages/monument_details_page.dart';
import 'package:skopski_vremeplov/pages/new_monument_page.dart';
import 'package:skopski_vremeplov/pages/new_tour_page.dart';
import 'package:skopski_vremeplov/pages/sign_out_page.dart';
import 'package:skopski_vremeplov/pages/tours_page.dart';

import '../modules/location.dart';
import '../modules/tour.dart';
import 'new_location_page.dart';

class MonumentsPage extends StatefulWidget {
  const MonumentsPage({
    super.key,
    required this.locations,
    required this.monuments,
    required this.tours,
  });

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;

  @override
  State<MonumentsPage> createState() => _MonumentsPageState();
}

class _MonumentsPageState extends State<MonumentsPage> {
  List<Tour> _tours = [];
  List<Monument> _monuments = [];
  List<Location> _locations = [];

  String? errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tours = widget.tours;
    _monuments = widget.monuments;
    _locations = widget.locations;
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MonumentsPage(
                      locations: _locations,
                      monuments: _monuments,
                      tours: _tours,
                    )));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _addLocationFunction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewLocation(
              addLocation: _addNewLocationToList,
            ),
          );
        });
  }

  _addNewLocationToList(Location location) {
    setState(() {
      _locations.add(location);
    });
  }

  void _addMonumentFunction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewMonument(
              addMonument: _addNewMonumentToList,
            ),
          );
        });
  }

  _addNewMonumentToList(Monument monument) {
    setState(() {
      _monuments.add(monument);
    });
  }

  @override
  Widget build(BuildContext context) {
    var isSignedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Знаменитости', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ToursPage(
                              locations: _locations,
                              monuments: _monuments,
                              tours: _tours)));
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
                          builder: (context) => GoogleMaps(_monuments)));
                },
                icon: const Icon(Icons.tour_outlined),
                iconSize: 30,
                color: Colors.white,
              ),
              if (isSignedIn) ...[
                IconButton(
                  icon: const Icon(Icons.add_location),
                  color: Colors.white,
                  onPressed: _addLocationFunction,
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  color: Colors.white,
                  onPressed: _addMonumentFunction,
                ),
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
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _monuments.length,
            itemBuilder: (context, index) {
              return Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MonumentDetailsPage(
                                locations: _locations,
                                monuments: _monuments,
                                tours: _tours,
                                monumentId: index,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Text color
                    elevation: 5, // Shadow elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoogleMaps([_monuments[index]])));
                              },
                              icon: const Icon(Icons.location_on),
                              iconSize: 30,
                              color: Colors.white,
                            ),
                            Spacer(),
                          ],
                        ),
                        ListTile(
                          title: Text(
                            _monuments[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (isSignedIn) ...[
                          IconButton(
                            icon: Icon(Icons.delete_rounded),
                            onPressed: () {
                              setState(() {
                                _monuments.removeAt(index);
                              });
                            },
                            color: Colors.white,
                          )
                        ]
                      ]),
                ),
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(12.0)),
                margin: EdgeInsets.all(10.0),
              );
            }));
  }
}
