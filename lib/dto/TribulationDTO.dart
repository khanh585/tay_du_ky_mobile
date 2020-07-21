import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';
import 'ToolDTO.dart';

class TribulationDTO {
  final int tribulation_id;
  final String name;
  final String description;
  final String address;
  final String time_start;
  final String time_end;
  final int times;
  final String url_file;
  final List<ActorDTO> actor;
  final List<ToolDTO> tool;

  TribulationDTO(
      {this.tribulation_id,
      this.name,
      this.description,
      this.address,
      this.time_start,
      this.time_end,
      this.times,
      this.url_file,
      this.actor,
      this.tool});

  factory TribulationDTO.fromJson(Map<String, dynamic> json) {
    Iterable tools = json['tool'];
    Iterable actors = json['actor'];

    return TribulationDTO(
      tribulation_id: json['tribulation_id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      time_start: json['time_start'],
      time_end: json['time_end'],
      times: json['times'],
      url_file: json['url_file'],
      actor: actors.map((e) => ActorDTO.fromJson(e)).toList(),
      tool: tools.map((e) => ToolDTO.fromJson(e)).toList(),
    );
  }

//          actor = [a.serialize() for a in self.actor]
//         tool = [t.serialize() for t in self.tool]
//         return {
//             "tribulation_id": self.tribulation_id,
//             "name": self.name,
//             "description": self.description,
//             "address": self.address,
//             "time_start": self.time_start,
//             "time_end": self.time_end,
//             "times": self.times,
//             "url_file": self.url_file,
//             "actor": actor,
//             "tool": tool
//         }
}
