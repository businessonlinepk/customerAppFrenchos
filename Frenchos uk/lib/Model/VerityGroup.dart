// To parse this JSON data, do
//
//     final verityGroup = verityGroupFromJson(jsonString);

import 'dart:convert';

import 'ItemVerity.dart';

List<VerityGroup> verityGroupFromJson(String str) => List<VerityGroup>.from(json.decode(str).map((x) => VerityGroup.fromJson(x)));

String verityGroupToJson(List<VerityGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VerityGroup {
  VerityGroup({
    this.verityGroupId = 0,
    this.fkItemId = 0,
    this.groupName = "",
    this.groupType = false,
    this.isDeleted = false,
    required this.dateAdded,
    this.selectedRadioId = 0,
    this.verities,
  });

  int verityGroupId;
  int fkItemId;
  String groupName;
  bool groupType;
  bool isDeleted;
  DateTime dateAdded;
  List<ItemVerity>? verities;
  int selectedRadioId;

  factory VerityGroup.fromJson(Map<String, dynamic> json) => VerityGroup(
    verityGroupId: json["verityGroupId"],
    fkItemId: json["fkItemId"],
    groupName: json["groupName"],
    groupType: json["groupType"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    selectedRadioId: json["selectedRadioId"],
    verities: List<ItemVerity>.from(json["verities"].map((x) => ItemVerity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "verityGroupId": verityGroupId,
    "fkItemId": fkItemId,
    "groupName": groupName,
    "groupType": groupType,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "selectedRadioId": selectedRadioId,
    //"verities": List<dynamic>.from(verities.map((x) => x.toJson())),
  };
}