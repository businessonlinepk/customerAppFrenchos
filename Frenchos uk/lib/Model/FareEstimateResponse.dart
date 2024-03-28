// To parse this JSON data, do
//
//     final fareEstimateResponse = fareEstimateResponseFromJson(jsonString);

import 'dart:convert';

FareEstimateResponse fareEstimateResponseFromJson(String str) => FareEstimateResponse.fromJson(json.decode(str));

String fareEstimateResponseToJson(FareEstimateResponse data) => json.encode(data.toJson());

class FareEstimateResponse {
  int code;
  Data data;
  String message;

  FareEstimateResponse({
    this.code = 21,
    required this.data,
    this.message = "",
  });

  factory FareEstimateResponse.fromJson(Map<String, dynamic> json) => FareEstimateResponse(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  int fareEst;
  String fareEstFormat;
  int distance;
  int time;
  String fareRange;
  int fareMin;
  int fareMax;

  Data({
    this.fareEst = 0,
    this.fareEstFormat = " ",
    this.distance = 0,
    this.time = 0,
    this.fareRange = "",
    this.fareMin = 0,
    this.fareMax = 0,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fareEst: json["fare_est"],
    fareEstFormat: json["fare_est_format"],
    distance: json["distance"],
    time: json["time"],
    fareRange: json["fare_range"],
    fareMin: json["fare_min"],
    fareMax: json["fare_max"],
  );

  Map<String, dynamic> toJson() => {
    "fare_est": fareEst,
    "fare_est_format": fareEstFormat,
    "distance": distance,
    "time": time,
    "fare_range": fareRange,
    "fare_min": fareMin,
    "fare_max": fareMax,
  };
}
