// To parse this JSON data, do
//
//     final restaurantArea = restaurantAreaFromJson(jsonString);

import 'dart:convert';

List<RestaurantArea> restaurantAreaFromJson(String str) => List<RestaurantArea>.from(json.decode(str).map((x) => RestaurantArea.fromJson(x)));

String restaurantAreaToJson(List<RestaurantArea> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantArea {
  int restaurantAreaId;
  int fkRestaurntId;
  int fkAreaId;
  double charges;
  DateTime dateAdded;
  String restaurntName;
  String areaName;

  RestaurantArea({
    this.restaurantAreaId = 0,
    this.fkRestaurntId = 0,
    this.fkAreaId = 0,
    this.charges = 0,
    required this.dateAdded,
    this.restaurntName = "",
    this.areaName = "",
  });

  factory RestaurantArea.fromJson(Map<String, dynamic> json) => RestaurantArea(
    restaurantAreaId: json["restaurantAreaId"],
    fkRestaurntId: json["fkRestaurntId"],
    fkAreaId: json["fkAreaId"],
    charges: json["charges"].toDouble(),
    dateAdded: DateTime.parse(json["dateAdded"]),
    restaurntName: json["restaurntName"],
    areaName: json["areaName"],
  );

  Map<String, dynamic> toJson() => {
    "restaurantAreaId": restaurantAreaId,
    "fkRestaurntId": fkRestaurntId,
    "fkAreaId": fkAreaId,
    "charges": charges,
    "dateAdded": dateAdded.toIso8601String(),
    "restaurntName": restaurntName,
    "areaName": areaName,
  };
}
