import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/admin.dart';
import 'package:tay_du_ky_app/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: LoginScreen(),
    ));
  }
}
