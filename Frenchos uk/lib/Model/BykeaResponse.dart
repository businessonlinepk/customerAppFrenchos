// To parse this JSON data, do
//
//     final bykeaResponse = bykeaResponseFromJson(jsonString);

import 'dart:convert';

BykeaResponse bykeaResponseFromJson(String str) => BykeaResponse.fromJson(json.decode(str));

String bykeaResponseToJson(BykeaResponse data) => json.encode(data.toJson());

class BykeaResponse {
  int code;
  Data data;
  bool success;

  BykeaResponse({
    this.code = 0,
    required this.data,
    required this.success,
  });

  factory BykeaResponse.fromJson(Map<String, dynamic> json) => BykeaResponse(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "success": success,
  };
}

class Data {
  String currentLat;
  String currentLng;
  String tripStatus;

  Data({
    this.currentLat = "",
    this.currentLng = "",
    this.tripStatus = "",
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentLat: json["current_lat"],
    currentLng: json["current_lng"],
    tripStatus: json["trip_status"],
  );

  Map<String, dynamic> toJson() => {
    "current_lat": currentLat,
    "current_lng": currentLng,
    "trip_status": tripStatus,
  };
}
