// To parse this JSON data, do
//
//     final bannerModelS = bannerModelSFromJson(jsonString);

import 'dart:convert';
import 'Restaurant.dart';

List<BannerModelS> bannerModelSFromJson(String str) => List<BannerModelS>.from(json.decode(str).map((x) => BannerModelS.fromJson(x)));

String bannerModelSToJson(List<BannerModelS> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModelS {
  BannerModelS({
    this.bannerId = 0,
    this.fkRestaurantId = 0,
    this.bannerName  = "",
    this.mobileBanner = "",
    this.webBanner = "",
    this.landingLink = "",
    this.isActive = true,
    required this.dateAdded,
    this.mobileImage,
    this.webImage,
    this.restaurant,
  });

  int bannerId;
  int fkRestaurantId;
  String bannerName;
  String mobileBanner;
  String webBanner;
  String landingLink;
  bool isActive;
  DateTime dateAdded;
  dynamic mobileImage;
  dynamic webImage;
  Restaurant? restaurant;

  factory BannerModelS.fromJson(Map<String, dynamic> json) => BannerModelS(
    bannerId: json["bannerId"],
    fkRestaurantId: json["fkRestaurantId"],
    bannerName: json["bannerName"],
    mobileBanner: json["mobileBanner"],
    webBanner: json["webBanner"],
    landingLink: json["landingLink"],
    isActive: json["isActive"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    mobileImage: json["mobileImage"],
    webImage: json["webImage"],
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "bannerId": bannerId,
    "fkRestaurantId": fkRestaurantId,
    "bannerName": bannerName,
    "mobileBanner": mobileBanner,
    "webBanner": webBanner,
    "landingLink": landingLink,
    "isActive": isActive,
    "dateAdded": dateAdded.toIso8601String(),
    "mobileImage": mobileImage,
    "webImage": webImage,
    "restaurant": restaurant!.toJson(),
  };
}
