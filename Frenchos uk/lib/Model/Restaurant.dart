import 'dart:convert';

List<Restaurant> restaurantsFromJson(String str) => List<Restaurant>.from(json.decode(str).map((x) => Restaurant.fromJson(x)));
Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(List<Restaurant> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Restaurant{

  Restaurant({
    this.restaurantId = 0,
    this.fkCityId = 0,
    this.fkAreaId = 0,
    this.name = "",
    this.ownerName = "Unknown",
    this.email = "test",
    this.primaryContact = "",
    this.secondaryContact = "",
    this.logo = "",
    this.address = "",
    this.landMark =" ",
    required this.dateAdded,
    this.isActive = true,
    this.isDeleted = false,

    this.status = false,
    required this.from,
    required this.to,
    this.message = "",
    this.instagram  = "",
    this.facebook  = "",
    this.youTube = "",
    this.whatsApp = "",

    this.minimumOrder = 0,
    this.minimumTime = 0,
    this.waitingTime = 30,
    this.latitude = 0,
    this.longitude = 0,
  });

  int restaurantId = 0;
  int fkCityId = 0;
  int fkAreaId = 0;
  String name = "";
  String ownerName = "Unknown";
  String email = "test";
  String primaryContact = "0";
  String secondaryContact ="0";
  String logo = "NotFound.png";
  String address = "";
  String landMark = "";
  DateTime dateAdded;
  bool isActive = true;
  bool isDeleted = false;

  bool status;
  DateTime from;
  DateTime to;
  String message;
  String instagram;
  String facebook;
  String youTube;
  String whatsApp;
  int waitingTime;

  int minimumOrder;
  int minimumTime;
  double latitude;
  double longitude;


  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurantId: json["restaurantId"],
    fkCityId: json["fkCityId"],
    fkAreaId: json["fkAreaId"],
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
    status: json["status"],
    from: DateTime.parse(json["from"]),
    to: DateTime.parse(json["to"]),
    waitingTime: json["waitingTime"],
    message: json["message"],
    instagram: json["instagram"],
    facebook: json["facebook"],
    youTube: json["youTube"],
    whatsApp: json["whatsApp"],
    minimumOrder: json["minimumOrder"],
    minimumTime: json["minimumTime"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "restaurantId": restaurantId,
    "fkCityId": fkCityId,
    "fkAreaId": fkAreaId,
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

    "status": status,
    "from": from.toIso8601String(),
    "to": to.toIso8601String(),
    "waitingTime": waitingTime,
    "message": message,
    "instagram": instagram,
    "facebook": facebook,
    "youTube": youTube,
    "whatsApp": whatsApp,
    "minimumOrder": minimumOrder,
    "minimumTime": minimumTime,
    "latitude": latitude,
    "longitude": longitude,
  };
}

