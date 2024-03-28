

// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';
import 'CategorySubModel.dart';
import 'Restaurant.dart';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
    this.itemId = 0,
    this.fkRestaurantId = 5,
    this.fkCategoryId = 0,
    required this.name,
    required this.description,
    this.imgUrl = "NotFound.png",
    this.tax = 0,
    this.discount = 0,
    required this.price,
    this.status = true,
    this.isActive = true,
    this.isDeleted = false,
    this.orderPosition = 0,
    required this.dateAdded,

    this.restaurant,
    this.categry,
  });

  int itemId;
  int fkRestaurantId;
  int fkCategoryId;
  String name;
  String description;
  String imgUrl;
  double tax;
  double price;
  double discount;
  int orderPosition;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Restaurant? restaurant;
  CategorySubModel? categry;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["itemId"],
    fkRestaurantId: json["fkRestaurantId"],
    fkCategoryId: json["fkCategoryId"],
    name: json["name"],
    description: json["description"],
    imgUrl: json["imgUrl"],
    tax: json["tax"].toDouble(),
    discount: json["discount"].toDouble(),
    price: json["price"].toDouble(),
    orderPosition: json["orderPosition"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    // restaurant: Restaurant.fromJson(json["restaurant"]),
    // categry: CategorySubModel.fromJson(json["categry"]),
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "fkRestaurantId": fkRestaurantId,
    "fkCategoryId": fkCategoryId,
    "name": name,
    "description": description,
    "imgUrl": imgUrl,
    "tax": tax,
    "discount": discount,
    "price": price,
    "orderPosition": orderPosition,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    //"restaurant": restaurant?.toJson(),
    //"categry": categry?.toJson(),
  };
}

