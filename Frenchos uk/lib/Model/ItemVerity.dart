// To parse this JSON data, do
//
//     final itemVerity = itemVerityFromJson(jsonString);

import 'dart:convert';

List<ItemVerity> itemVerityFromJson(String str) => List<ItemVerity>.from(json.decode(str).map((x) => ItemVerity.fromJson(x)));

String itemVerityToJson(List<ItemVerity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemVerity {
  ItemVerity({
    this.itemVerityId= 0,
    this.fkItemId= 0,
    this.name = "",
    this.addPrice = 0,
    this.status = false,
    this.statuscheck = false,
    this.isActive = true,
    this.isDeleted = false,
    required this.dateAdded ,
  });

  int itemVerityId;
  int fkItemId;
  String name;
  int addPrice;
  bool status;
  bool statuscheck; // this status add by me model class side this not from api side
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;

  factory ItemVerity.fromJson(Map<String, dynamic> json) => ItemVerity(
    itemVerityId: json["itemVerityId"],
    fkItemId: json["fkItemId"],
    name: json["name"],
    addPrice: json["addPrice"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "itemVerityId": itemVerityId,
    "fkItemId": fkItemId,
    "name": name,
    "addPrice": addPrice,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
  };
}