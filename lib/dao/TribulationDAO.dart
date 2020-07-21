import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tay_du_ky_app/dto/TribulationDTO.dart';
import 'package:tay_du_ky_app/util/config.dart';

Future<List<TribulationDTO>> fetchListTribulationDTO() async {
  final response = await http.get(
    PREFIX + '/admin/tribulation/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => TribulationDTO.fromJson(e)).toList();
    // return list.map((model) => TribulationDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load tribulation');
  }
}

Future<List<TribulationDTO>> fetchListTribulationDTOByActorID(
    String actorID) async {
  final response = await http.get(
    PREFIX + '/admin/tribulation/actor/' + actorID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => TribulationDTO.fromJson(e)).toList();
    // return list.map((model) => TribulationDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load tribulation');
  }
}

Future<int> createTribulation(TribulationDTO dto) async {
  final http.Response response = await http.post(
    PREFIX + "/admin/tribulation/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "name": dto.name,
      "description": dto.description,
      "address": dto.address,
      "time_start": dto.time_start.toString(),
      "time_end": dto.time_end.toString(),
      "times": dto.times.toString(),
    }),
  );
  if (response.statusCode == 201) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to create tribulation');
  }
}

Future<String> deleteTribulation(String tribulationID) async {
  final http.Response response = await http.delete(
    PREFIX + "/admin/tribulation/" + tribulationID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to delete tribulation');
  }
}

Future<String> updateTribulation(
    String TribulationID, TribulationDTO dto) async {
  final http.Response response = await http.put(
    PREFIX + "/admin/tribulation/" + TribulationID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "times": dto.times.toString(),
      "name": dto.name,
      "description": dto.description,
      "url_file": dto.url_file,
      "address": dto.address,
      "time_start": dto.time_start,
      "time_end": dto.time_end,
      "url_file": dto.url_file,
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  }
  if (response.statusCode == 500) {
    return 'false';
  } else {
    throw Exception('Failed to update tribulation');
  }
}

Future<TribulationDTO> fetchTribulationDTO(String tribulationID) async {
  final response =
      await http.get(PREFIX + '/admin/tribulation/' + tribulationID);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    return TribulationDTO.fromJson(result);
  } else {
    throw Exception('Failed to load tribulation');
  }
}
