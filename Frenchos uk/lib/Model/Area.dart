// To parse this JSON data, do
//
//     final area = areaFromJson(jsonString);

import 'dart:convert';

List<Area> areaFromJson(String str) => List<Area>.from(json.decode(str).map((x) => Area.fromJson(x)));

String areaToJson(List<Area> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Area {
  int areaId;
  String areaName;
  bool isDeleted;
  DateTime dateAdded;

  Area({
    this.areaId = 0,
    this.areaName = "",
    this.isDeleted = false,
    required this.dateAdded,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    areaId: json["areaId"],
    areaName: json["areaName"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "areaId": areaId,
    "areaName": areaName,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
  };
}
