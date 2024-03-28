
// To parse this JSON data, do
//
//     final categry = categryFromJson(jsonString);

import 'dart:convert';

import 'Item.dart';
import 'Menu.dart';

List<Categry> categryFromJson(String str) => List<Categry>.from(json.decode(str).map((x) => Categry.fromJson(x)));

String categryToJson(List<Categry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categry {

  Categry({
    this.categoryId =0,
    this.fkMenuId = 0,
    required this.name,
    this.status = true,
    this.isActive = true,
    this.isDeleted = false,
    required this.dateAdded,
    this.menu,
    this.items,
  });

  int categoryId;
  int fkMenuId;
  String name;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Menu? menu;
  List<Item>? items;

  factory Categry.fromJson(Map<String, dynamic> json) => Categry(
    categoryId: json["categoryId"],
    fkMenuId: json["fkMenuId"],
    name: json["name"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    //menu: Menu.fromJson(json["menu"]),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "fkMenuId": fkMenuId,
    "name": name,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "items": List<dynamic>.from(items!.map((x) => x)),
//"menu": menu?.toJson(),
  };
}
