// To parse this JSON data, do
//
//     final customerProfile = customerProfileFromJson(jsonString);

import 'dart:convert';

import 'Restaurant.dart';

CustomerProfile customerProfileFromJson(String str) => CustomerProfile.fromJson(json.decode(str));

String customerProfileToJson(CustomerProfile data) => json.encode(data.toJson());

class CustomerProfile {
  CustomerProfile({
    required this.customerId,
    required this.fkCityId,
    required this.fkRestaurantId,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.landmark,
    required this.dateAdded,
    required this.isActive,
    required this.isDeleted,
    required this.restaurant,
  });

  int customerId;
  int fkCityId;
  int fkRestaurantId;
  String name;
  String email;
  String contact;
  String address;
  String landmark;
  String dateAdded;
  bool isActive;
  bool isDeleted;
  Restaurant restaurant;

  factory CustomerProfile.fromJson(Map<String, dynamic> json) => CustomerProfile(
    customerId: json["customerId"],
    fkCityId: json["fkCityId"],
    fkRestaurantId: json["fkRestaurantId"],
    name: json["name"],
    email: json["email"],
    contact: json["contact"],
    address: json["address"],
    landmark: json["landmark"],
    dateAdded: json["dateAdded"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "fkCityId": fkCityId,
    "fkRestaurantId": fkRestaurantId,
    "name": name,
    "email": email,
    "contact": contact,
    "address": address,
    "landmark": landmark,
    "dateAdded": dateAdded,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "restaurant": restaurant.toJson(),
  };
}

/*class Restaurant {
  Restaurant({
    required this.restaurantId,
    required this.fkCityId,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.primaryContact,
    required this.secondaryContact,
    required this.logo,
    required this.address,
    required this.landMark,
    required this.dateAdded,
    required this.isActive,
    required this.isDeleted,
  });

  int restaurantId;
  int fkCityId;
  String name;
  String ownerName;
  String email;
  String primaryContact;
  String secondaryContact;
  String logo;
  String address;
  String landMark;
  DateTime dateAdded;
  bool isActive;
  bool isDeleted;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurantId: json["restaurantId"],
    fkCityId: json["fkCityId"],
    name: json["name"],
    ownerName: json["ownerName"],
    email: json["email"],
    primaryContact: json["primaryContact"],
    secondaryContact: json["secondaryContact"],
    logo: json["logo"],
    address: json["address"],
    landMark: json["landMark"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "restaurantId": restaurantId,
    "fkCityId": fkCityId,
    "name": name,
    "ownerName": ownerName,
    "email": email,
    "primaryContact": primaryContact,
    "secondaryContact": secondaryContact,
    "logo": logo,
    "address": address,
    "landMark": landMark,
    "dateAdded": dateAdded.toIso8601String(),
    "isActive": isActive,
    "isDeleted": isDeleted,
  };
}*/
