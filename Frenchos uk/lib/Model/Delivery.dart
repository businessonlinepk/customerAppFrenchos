// To parse this JSON data, do
//
//     final delivery = deliveryFromJson(jsonString);

import 'dart:convert';

import 'Restaurant.dart';

List<Delivery> deliveryFromJson(String str) => List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));

String deliveryToJson(List<Delivery> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Delivery {
  Delivery({
      this.deliveryId = 0,
      this.fkResturantId = 0,
      this.name = "",
      this.amount = 0,
      this.message = "",
      this.isActive= false,
    required this.dateAdded,
      this.isDeleted = false,
      this.restaurant,
  });

  int deliveryId;
  int fkResturantId;
  String name;
  int amount;
  String message;
  bool isActive;
  DateTime dateAdded;
  bool isDeleted;
  Restaurant? restaurant;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    deliveryId: json["deliveryId"],
    fkResturantId: json["fkResturantId"],
    name: json["name"],
    amount: json["amount"],
    message: json["message"],
    isActive: json["isActive"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    isDeleted: json["isDeleted"],
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "deliveryId": deliveryId,
    "fkResturantId": fkResturantId,
    "name": name,
    "amount": amount,
    "message": message,
    "isActive": isActive,
    "dateAdded": dateAdded.toIso8601String(),
    "isDeleted": isDeleted,
    "restaurant": restaurant!.toJson(),
  };
}

