import 'Restaurant.dart';

class Customer {
  static int itemsCount = 0;
  Customer({
    this.customerId = 0,
    this.fkAreaId = 0,
    this.fkCityId = 0,
    this.fkRestaurantId = 0,
    this.name = "",
    this.email = "",
    this.contact = "",
    this.token = "",
    this.address = "",
    this.landmark = "",
    this.secondaryContact = "",
    required this.dateAdded,
    this.deletedDate,
    this.isActive = true,
    this.isDeleted = false,
    this.restaurant,
    this.latitude = 0,
    this.longitude = 0,
  });

  int customerId;
  int fkCityId;
  int fkAreaId;
  int fkRestaurantId;
  String name;
  String email;
  String contact;
  String token;
  String secondaryContact;
  String address;
  String landmark;
  DateTime dateAdded;
  DateTime? deletedDate;
  bool isActive;
  bool isDeleted;
  Restaurant? restaurant;
  double latitude;
  double longitude;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customerId: json["customerId"],
    fkCityId: json["fkCityId"],
    fkAreaId: json["fkAreaId"],
    fkRestaurantId: json["fkRestaurantId"],
    name: json["name"],
    email: json["email"],
    contact: json["contact"],
    token: json["token"],
    secondaryContact: json["secondaryContact"],
    address: json["address"],
    landmark: json["landmark"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    deletedDate: DateTime.parse(json["deletedDate"]),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "fkCityId": fkCityId,
    "fkAreaId": fkAreaId,
    "fkRestaurantId": fkRestaurantId,
    "name": name,
    "email": email,
    "token": token,
    "contact": contact,
    "secondaryContact": secondaryContact,
    "address": address,
    "landmark": landmark,
    "dateAdded": dateAdded.toIso8601String(),
    "deletedDate": deletedDate!.toIso8601String(),
    "isActive": isActive,
    "isDeleted": isDeleted,
    "latitude": latitude,
    "longitude": longitude,
    "restaurant": restaurant?.toJson(),
  };
}