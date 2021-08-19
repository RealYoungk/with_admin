import 'dart:convert';

Player playerFromJson(String str) => Player.fromJson(json.decode(str));

String playerToJson(Player data) => json.encode(data.toJson());

class Player {
  Player({
    required this.name,
    required this.time,
  });

  String name;
  String time;

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    name: json["name"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "time": time,
  };
}
