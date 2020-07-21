import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/util/config.dart';

class Home extends StatefulWidget {
  final String role;

  const Home({Key key, this.role}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text('Hello ' + ROLE),
      ),
    );
  }
}
