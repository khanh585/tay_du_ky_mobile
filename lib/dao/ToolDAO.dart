import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tay_du_ky_app/dto/ToolDTO.dart';
import 'package:tay_du_ky_app/util/config.dart';

Future<List<ToolDTO>> fetchListToolDTO() async {
  final response = await http.get(
    PREFIX + '/admin/tool/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTHORIZATION_TOKEN,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((e) => ToolDTO.fromJson(e)).toList();
    // return list.map((model) => ToolDTO.fromJson(model)).toList();
  }
  if (response.statusCode == 401) {
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load tool');
  }
}

Future<int> createTool(ToolDTO dto) async {
  final http.Response response = await http.post(
    PREFIX + "/admin/tool/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "quantity": dto.quantity.toString(),
      "name": dto.name,
      "description": dto.description,
      "image": dto.image,
      "status": dto.status,
    }),
  );
  if (response.statusCode == 201) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to create tool');
  }
}

Future<String> deleteTool(String toolID) async {
  final http.Response response = await http.delete(
    PREFIX + "/admin/tool/" + toolID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to delete tool');
  }
}

Future<String> updateTool(String toolID, ToolDTO dto) async {
  final http.Response response = await http.put(
    PREFIX + "/admin/tool/" + toolID,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "quantity": dto.quantity.toString(),
      "name": dto.name,
      "description": dto.description,
      "image": dto.image,
      "status": dto.status,
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to update tool');
  }
}

Future<ToolDTO> fetchToolDTO(String toolID) async {
  final response = await http.get(PREFIX + '/admin/tool/' + toolID);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final result = json.decode(response.body);
    return ToolDTO.fromJson(result);
  } else {
    throw Exception('Failed to load tool');
  }
}
