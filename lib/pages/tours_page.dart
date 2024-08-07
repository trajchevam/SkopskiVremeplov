import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skopski_vremeplov/modules/monument.dart';
import 'package:skopski_vremeplov/pages/home_page.dart';
import 'package:skopski_vremeplov/pages/login_register_page.dart';
import 'package:skopski_vremeplov/pages/monuments_page.dart';
import 'package:skopski_vremeplov/pages/new_tour_page.dart';

import '../modules/location.dart';
import '../modules/tour.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({
    super.key,
    required this.locations,
    required this.monuments,
    required this.tours,
  });

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> {
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
                builder: (context) => ToursPage(
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

  void _addTourFunction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTour(
              addTour: _addNewTourToList,
              locations: _locations,
              monuments: _monuments,
              tours: _tours,
            ),
          );
        });
  }

  _addNewTourToList(Tour tour) {
    setState(() {
      _tours.add(tour);
    });
  }

  @override
  Widget build(BuildContext context) {
    var isSignedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text('Тури', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              locations: _locations,
                              monuments: _monuments,
                              tours: _tours)));
                },
                icon: const Icon(Icons.arrow_circle_left),
                iconSize: 30,
                color: Colors.white,
              ),
              Spacer(),
              if (isSignedIn) ...[
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: _addTourFunction,
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
            itemCount: _tours.length,
            itemBuilder: (context, index) {
              return Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonumentsPage(
                                    locations: _locations,
                                monuments: _tours[index].monuments,
                                    tours: _tours,
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
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  _tours[index].name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              subtitle: Text(
                                "Потребни денови: " +
                                    '${_tours[index].daysNeeded.toString()}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                if (isSignedIn) ...[
                                  IconButton(
                                    icon: Icon(Icons.delete_rounded),
                                    onPressed: () {
                                      setState(() {
                                        _tours.removeAt(index);
                                      });
                                    },
                                    color: Colors.black,
                                  )
                                ],
                                Spacer()
                              ],
                            )
                          ]),
                    )),
                margin: EdgeInsets.all(10.0),
              );
            }));
  }
}
