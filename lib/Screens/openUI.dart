import 'package:flutter/material.dart';
import 'package:login_app/Screens/LoginForm.dart';
import 'package:login_app/Screens/TeacherLoginForm.dart';

void main() {
  runApp(ClubApp());
}

class ClubApp extends StatelessWidget {
  ClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpeningUI(),
    );
  }
}

class OpeningUI extends StatefulWidget {
  const OpeningUI({
    Key? key,
  }) : super(key: key);

  @override
  _OpenPageState createState() {
    return _OpenPageState();
  }
}

class _OpenPageState extends State<OpeningUI> {
  @override
  Widget build(BuildContext context) {
    // 1
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Directory'),
      ),
      // 2
      body: Stack(
        children: <Widget>[
          Positioned(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              top: 20,
              left: 20,
              right: 20),
          Positioned(
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.center,
                'Welcome to the Bronx Science Club Directory!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  fontFamily: "Arial",
                ),
              ),
            ),
            top: 250,
            left: 100,
            right: 100,
          ),
          Positioned(
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.center,
                'Please select your login below',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                    fontFamily: "Arial",
                    color: Color.fromARGB(255, 128, 128, 128)),
              ),
            ),
            top: 325,
            left: 100,
            right: 100,
          ),
          Positioned(
            child: ElevatedButton(
              child: Text('Teacher Login'),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 30, fontFamily: "Arial")),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 85, 169, 238)),
                  fixedSize: MaterialStateProperty.all(const Size(500, 100)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // 10
                      return TeacherLoginForm();
                    },
                  ),
                );
              },
            ),
            top: 415,
            right: 180,
          ),
          Positioned(
            child: ElevatedButton(
              child: Text('Student Login'),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 30, fontFamily: "Arial")),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 85, 169, 238)),
                  fixedSize: MaterialStateProperty.all(const Size(500, 100)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // 10
                      return LoginForm();
                    },
                  ),
                );
              },
            ),
            top: 415,
            left: 180,
          ),
        ],
      ),
    );
  }
}
