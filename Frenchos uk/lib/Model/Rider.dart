// To parse this JSON data, do
//
//     final rider = riderFromJson(jsonString);


// To parse this JSON data, do
//
//     final rider = riderFromJson(jsonString);

import 'dart:convert';

import 'Restaurant.dart';

List<Rider> riderFromJson(String str) => List<Rider>.from(json.decode(str).map((x) => Rider.fromJson(x)));

String riderToJson(List<Rider> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rider {

  Rider({
    this.riderId = 0,
    this.fkCityId = 0,
    this.fkRestaurantId = 0,
    this.fName = "",
    this.lName= "",
    required this.dob,
    this.gender = "m",
    this.cnic= "",
    this.contactNo= "",
    this.email= "",
    this.imgUrl= "",
    this.cnicFront= "",
    this.cnicBack= "",
    this.rideName= "",
    this.rideColor= "",
    this.rideModel= "",
    this.riderLicense= "",
    this.bikePapers= "",
    required this.dateAdded,
    this.isActive= true,
    this.isVerified= true,
    this.isDeleted = false,
    this.restaurant,
    this.token ="",
    this.restaurantName ="",
    this.areaName ="",
  });

  int riderId;
  int fkCityId;
  int fkRestaurantId;
  String fName;
  String lName;
  DateTime dob;
  String gender;
  String cnic;
  String contactNo;
  String email;
  String imgUrl;
  String cnicFront;
  String cnicBack;
  String rideName;
  String rideColor;
  String rideModel;
  String riderLicense;
  String bikePapers;
  DateTime dateAdded;
  bool isActive;
  bool isVerified;
  bool isDeleted;
  Restaurant? restaurant;
  String token;
  String restaurantName;
  String areaName;

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
    riderId: json["riderId"],
    fkCityId: json["fkCityId"],
    fkRestaurantId: json["fkRestaurantId"],
    fName: json["fName"],
    lName: json["lName"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    cnic: json["cnic"],
    contactNo: json["contactNo"],
    email: json["email"],
    imgUrl: json["imgUrl"],
    cnicFront: json["cnicFront"],
    cnicBack: json["cnicBack"],
    rideName: json["rideName"],
    rideColor: json["rideColor"],
    rideModel: json["rideModel"],
    riderLicense: json["riderLicense"],
    bikePapers: json["bikePapers"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    isActive: json["isActive"],
    isVerified: json["isVerified"],
    isDeleted: json["isDeleted"],
    token: json["token"],
    restaurantName: json["restaurantName"],
    areaName: json["areaName"],
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "riderId": riderId,
    "fkCityId": fkCityId,
    "fkRestaurantId": fkRestaurantId,
    "fName": fName,
    "lName": lName,
    "dob": dob.toIso8601String(),
    "gender": gender,
    "cnic": cnic,
    "contactNo": contactNo,
    "email": email,
    "imgUrl": imgUrl,
    "cnicFront": cnicFront,
    "cnicBack": cnicBack,
    "rideName": rideName,
    "rideColor": rideColor,
    "rideModel": rideModel,
    "riderLicense": riderLicense,
    "bikePapers": bikePapers,
    "dateAdded": dateAdded.toIso8601String(),
    "isActive": isActive,
    "isVerified": isVerified,
    "isDeleted": isDeleted,
    "token": token,
    //"restaurant": restaurant.toJson(),
  };
}

