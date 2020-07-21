import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/util/config.dart';

Future<List<ActorDTO>> fetchListActorDTO() async {
  final response = await http.get(
    PREFIX + '/admin/actor/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => ActorDTO.fromJson(e)).toList();
    // return list.map((model) => ActorDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load actor');
  }
}

Future<List<ActorDTO>> fetchListActorDTOByTribulation(
    String tribulationID) async {
  final response = await http.get(
    PREFIX + '/admin/actor/tribulation/' + tribulationID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => ActorDTO.fromJson(e)).toList();
    // return list.map((model) => ActorDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load actor');
  }
}

Future<int> createActor(ActorDTO dto) async {
  final http.Response response = await http.post(
    PREFIX + "/admin/actor/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "name": dto.name,
      "description": dto.description,
      "email": dto.email,
      "phone": dto.phone,
      "role": dto.role,
      "password": dto.password
    }),
  );
  if (response.statusCode == 201) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to create actor');
  }
}

Future<String> deleteActor(String actorID) async {
  final http.Response response = await http.delete(
    PREFIX + "/admin/actor/" + actorID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to delete actor');
  }
}

Future<bool> updateActor(String actorID, ActorDTO dto) async {
  final http.Response response = await http.put(
    PREFIX + "/admin/actor/" + actorID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "name": dto.name,
      "description": dto.description,
      "email": dto.email,
      "phone": dto.phone,
      "role": dto.role,
      "image": dto.image,
    }),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<ActorDTO> fetchActorDTO(String actorID) async {
  final response = await http.get(PREFIX + '/admin/actor/' + actorID);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    return ActorDTO.fromJson(result);
  } else {
    throw Exception('Failed to load actor');
  }
}

Future<String> addActorIntoTribulation(
    String tribulationID, String actorID, String name) async {
  final http.Response response = await http.post(
    PREFIX + "/admin/tribulation/" + tribulationID + "/add-actor",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "character_name": name,
      "actor_id": actorID.toString(),
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  }
  if (response.statusCode == 403) {
    return 'false';
  } else {
    throw Exception('Failed to load actor');
  }
}

Future<bool> removeActor(String tribulationID, String actorID) async {
  final http.Response response = await http.put(
    PREFIX + "/admin/tribulation/" + tribulationID + "/remove-actor",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'UserID': USER_ID,
    },
    body: jsonEncode(<String, String>{
      "actor_id": actorID,
    }),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to delete actor');
  }
}
