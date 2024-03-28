

// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

import 'Restaurant.dart';

List<Menu> menuFromJson(String str) => List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

String menuToJson(List<Menu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menu {
  Menu({
    required this.menuId,
    required this.fkRestaurantId,
    required this.name,
     this.description = "Not description found",
     this.status = true,
     this.isActive = true,
     this.isDeleted = false,
    required this.dateAdded,
    this.restaurant,
    required this.monStart,
    required this.monEnd,
    required this.tueStart,
    required this.tueEnd,
    required this.wedStart,
    required this.wedEnd,
    required this.thrStart,
    required this.thrEnd,
    required this.friStart,
    required this.friEnd,
    required this.satStart,
    required this.satEnd,
    required this.sunStart,
    required this.sunEnd ,
  });

  int menuId;
  int fkRestaurantId;
  String name;
  String description;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Restaurant? restaurant;
  DateTime monStart;
  DateTime monEnd;
  DateTime tueStart;
  DateTime tueEnd;
  DateTime wedStart;
  DateTime wedEnd;
  DateTime thrStart;
  DateTime thrEnd;
  DateTime friStart;
  DateTime friEnd;
  DateTime satStart;
  DateTime satEnd;
  DateTime sunStart;
  DateTime sunEnd;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    menuId: json["menuId"],
    fkRestaurantId: json["fkRestaurantId"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    monStart: DateTime.parse(json["monStart"]),
    monEnd: DateTime.parse(json["monEnd"]),
    tueStart: DateTime.parse(json["tueStart"]),
    tueEnd: DateTime.parse(json["tueEnd"]),
    wedStart: DateTime.parse(json["wedStart"]),
    wedEnd: DateTime.parse(json["wedEnd"]),
    thrStart: DateTime.parse(json["thrStart"]),
    thrEnd: DateTime.parse(json["thrEnd"]),
    friStart: DateTime.parse(json["friStart"]),
    friEnd: DateTime.parse(json["friEnd"]),
    satStart: DateTime.parse(json["satStart"]),
    satEnd: DateTime.parse(json["satEnd"]),
    sunStart: DateTime.parse(json["sunStart"]),
    sunEnd: DateTime.parse(json["sunEnd"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "fkRestaurantId": fkRestaurantId,
    "name": name,
    "description": description,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "monStart": monStart.toIso8601String(),
    "monEnd": monEnd.toIso8601String(),
    "tueStart": tueStart.toIso8601String(),
    "tueEnd": tueEnd.toIso8601String(),
    "wedStart": wedStart.toIso8601String(),
    "wedEnd": wedEnd.toIso8601String(),
    "thrStart": thrStart.toIso8601String(),
    "thrEnd": thrEnd.toIso8601String(),
    "friStart": friStart.toIso8601String(),
    "friEnd": friEnd.toIso8601String(),
    "satStart": satStart.toIso8601String(),
    "satEnd": satEnd.toIso8601String(),
    "sunStart": sunStart.toIso8601String(),
    "sunEnd": sunEnd.toIso8601String(),
    //"restaurant": restaurant?.toJson(),
  };
}
