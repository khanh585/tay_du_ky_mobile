import 'dart:io';
import 'package:tay_du_ky_app/admin.dart';
import 'package:tay_du_ky_app/util/config.dart';
import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/LoginDAO.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  bool flag;
  bool wait;

  @override
  void initState() {
    super.initState();
    flag = true;
    wait = false;
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    _Signin();
    super.dispose();
  }

  void _Signin() async {
    String email = txtEmail.text;
    String password = txtPassword.text;
    setState(() {
      wait = true;
    });
    try {
      await SignIn(email, password).then((result) => {
            ROLE = result[0],
            USER_ID = result[1].toString(),
            if (result != [])
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                ),
              }
          });
    } catch (Exception) {
      setState(() {
        flag = false;
        wait = false;
      });
      print('ERROR');
    }
    setState(() {
      flag = true;
      wait = false;
    });
    // dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Container(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/login.jpg"))),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: txtEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: txtPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (!wait) {
                            _Signin();
                          }
                        },
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.green[300],
                        child: Container(
                          child: wait
                              ? CircularProgressIndicator(
                                  strokeWidth: 3,
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      flag ? '' : 'Login fail',
                      style: TextStyle(color: Colors.red[600], fontSize: 18),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
