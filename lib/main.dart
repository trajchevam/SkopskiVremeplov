import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skopski_vremeplov/pages/home_page.dart';
import 'package:skopski_vremeplov/pages/tours_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'modules/monument.dart';
import 'modules/tour.dart';
import 'modules/location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Tour> _tours = [];
  List<Monument> _monuments = [];
  List<Location> _locations = [];

  @override
  void initState() {

    _monuments = Monument.getMonuments();
    _locations = Location.getLocations();

    _tours.add(Tour(1, "Центарот на градот", 1, [Monument.monument1, Monument.monument2, Monument.monument3, Monument.monument4,]));
    _tours.add(Tour(1, "Во природа", 2, [Monument.monument5, Monument.monument6, Monument.monument7,]));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: HomePage(locations: _locations,monuments: _monuments, tours: _tours,),
    );
  }
}