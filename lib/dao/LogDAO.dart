import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tay_du_ky_app/dto/LogDTO.dart';
import 'package:tay_du_ky_app/util/config.dart';

Future<List<LogDTO>> fetchListLogDTO() async {
  final response = await http.get(
    PREFIX + '/log/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => LogDTO.fromJson(e)).toList();
    // return list.map((model) => LogDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load actor');
  }
}
