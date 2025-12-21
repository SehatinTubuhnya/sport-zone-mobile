import 'dart:convert';

ActionLog actionLogFromJson(String str) => ActionLog.fromJson(json.decode(str));

String actionLogToJson(ActionLog data) => json.encode(data.toJson());

class ActionLog {
  String id;
  DateTime timestamp;
  String actor;
  String action;

  ActionLog({
    required this.id,
    required this.timestamp,
    required this.actor,
    required this.action,
  });

  factory ActionLog.fromJson(Map<String, dynamic> json) => ActionLog(
    id: json["id"],
    timestamp: DateTime.parse(json["timestamp"]),
    actor: json["actor"],
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "timestamp": timestamp.toIso8601String(),
    "actor": actor,
    "action": action,
  };
}
