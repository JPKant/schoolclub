import 'package:flutter/material.dart';
import 'package:login_app/Screens/HomeForm.dart';
import 'package:login_app/Screens/HomePage.dart';
import 'package:login_app/Screens/openUI.dart';

import 'Screens/LoginForm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bronx Science Club App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpeningUI(),
    );
  }
}
