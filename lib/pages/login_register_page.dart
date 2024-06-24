import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skopski_vremeplov/pages/tours_page.dart';

import '../auth_dart.dart';
import '../modules/location.dart';
import '../modules/monument.dart';
import '../modules/tour.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.locations,
    required this.monuments,
    required this.tours,
  });

  final List<Location> locations;
  final List<Monument> monuments;
  final List<Tour> tours;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      ).then((value) => {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ToursPage(locations: _locations,monuments: _monuments, tours: _tours,)))
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      ).then((value) => {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ToursPage(locations: _locations,monuments: _monuments, tours: _tours,)))
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }

  Widget _title(){
    return isLogin ? Text('Најави се', style: TextStyle(color: Colors.white)) : Text('Регистрирај се', style: TextStyle(color: Colors.white));
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      obscureText: title.compareTo("е-пошта") != 0,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.deepOrange)
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hmmm ? $errorMessage');
  }

  Widget _submitButton(){
    return ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Најави се' : 'Регистрирај се', style: TextStyle(color: Colors.deepOrange),),);
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: (){
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Регистрација' : 'Најава', style: TextStyle(color: Colors.deepOrange),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: _title(), actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ToursPage(locations: _locations,monuments: _monuments, tours: _tours,)));
            },
            child: const Text("Тури", style: TextStyle(color: Colors.orange),),
          ),
      ]),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('е-пошта', _controllerEmail),
            _entryField('лозинка', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton()
          ],
        ),
      ),
    );
  }
}
