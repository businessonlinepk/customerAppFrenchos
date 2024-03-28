// To parse this JSON data, do
//
//     final customerAddress = customerAddressFromJson(jsonString);

import 'dart:convert';

List<CustomerAddress> customerAddressFromJson(String str) => List<CustomerAddress>.from(json.decode(str).map((x) => CustomerAddress.fromJson(x)));

String customerAddressToJson(List<CustomerAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerAddress {
  CustomerAddress({
    this.addressId = 0,
    this.fkCustomerId = 0,
    this.fkAreaId = 0,
    this.address = "",
    this.landMark ="",
    this.latitude = 0,
    this.longitude = 0,
  });

  int addressId;
  int fkCustomerId;
  int fkAreaId;
  String address;
  String landMark;
  double latitude;
  double longitude;

  factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
    addressId: json["addressId"],
    fkCustomerId: json["fkCustomerId"],
    fkAreaId: json["fkAreaId"],
    address: json["address"],
    landMark: json["landMark"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "addressId": addressId,
    "fkCustomerId": fkCustomerId,
    "fkAreaId": fkAreaId,
    "address": address,
    "landMark": landMark,
    "latitude": latitude,
    "longitude": longitude,
  };
}
