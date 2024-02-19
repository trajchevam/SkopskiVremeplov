import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skopski_vremeplov/modules/monument.dart';
import 'package:skopski_vremeplov/pages/exam%20files/calendar.dart';
import 'package:skopski_vremeplov/pages/login_register_page.dart';
import 'package:skopski_vremeplov/pages/google_maps_page.dart';
import 'package:skopski_vremeplov/pages/monument_details_page.dart';
import 'package:skopski_vremeplov/pages/monuments_page.dart';
import 'package:skopski_vremeplov/pages/new_monument_page.dart';
import 'package:skopski_vremeplov/pages/new_tour_page.dart';
import 'package:skopski_vremeplov/pages/sign_out_page.dart';
import 'package:skopski_vremeplov/pages/tours_page.dart';

import '../modules/location.dart';
import '../modules/tour.dart';
import 'new_location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.locations,
    required this.monuments,
    required this.tours,
  }) : super(key: key);

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              locations: _locations,
              monuments: _monuments,
              tours: _tours,
            ),
          ),
        );
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
            onPressed: () {},
            icon: const Icon(Icons.circle),
            iconSize: 30,
            color: Colors.orange,
          ),
          Spacer(),
          if (isSignedIn)
            ElevatedButton(
              onPressed: _signOut,
              child: const Text(
                "Одјави се",
                style: TextStyle(color: Colors.orange),
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      locations: _locations,
                      monuments: _monuments,
                      tours: _tours,
                    ),
                  ),
                );
              },
              child: const Text(
                "Најави се",
                style: TextStyle(color: Colors.orange),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToursPage(
                      locations: _locations,
                      monuments: _monuments,
                      tours: _tours,
                    ),
                  ),
                );
              },
              child: Text(
                'Тури',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MonumentsPage(
                      locations: _locations,
                      monuments: _monuments,
                      tours: _tours,
                    ),
                  ),
                );
              },
              child: Text(
                'Знаменитости',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
