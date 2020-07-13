import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tay_du_ky_app/util/config.dart';

Future<String> SignIn(String email, String password) async {
  try {
    final http.Response response = await http.post(
      "https://flaskserverprm.herokuapp.com/login/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 401) {
      return "";
    } else {
      throw Exception('Failed to login');
    }
  } catch (e) {
    print(e);
    return "";
  }
}
