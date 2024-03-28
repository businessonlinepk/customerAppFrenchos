// To parse this JSON data, do
//
//     final customerToken = customerTokenFromJson(jsonString);

import 'dart:convert';

List<CustomerToken> customerTokenFromJson(String str) => List<CustomerToken>.from(json.decode(str).map((x) => CustomerToken.fromJson(x)));

String customerTokenToJson(List<CustomerToken> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerToken {
  int customerTokenId;
  int fkRestaurantId;
  String uniqueId;
  String token;

  CustomerToken({
    this.customerTokenId = 0,
    this.fkRestaurantId = 0,
    this.uniqueId = "",
    this.token = "",
  });

  factory CustomerToken.fromJson(Map<String, dynamic> json) => CustomerToken(
    customerTokenId: json["CustomerTokenId"],
    fkRestaurantId: json["FkRestaurantId"],
    uniqueId: json["UniqueId"],
    token: json["Token"],
  );

  Map<String, dynamic> toJson() => {
    "CustomerTokenId": customerTokenId,
    "FkRestaurantId": fkRestaurantId,
    "UniqueId": uniqueId,
    "Token": token,
  };
}
