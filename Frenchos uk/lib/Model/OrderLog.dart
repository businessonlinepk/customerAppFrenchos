// To parse this JSON data, do
//
//     final orderLog = orderLogFromJson(jsonString);

import 'dart:convert';

List<OrderLog> orderLogFromJson(String str) => List<OrderLog>.from(json.decode(str).map((x) => OrderLog.fromJson(x)));

String orderLogToJson(List<OrderLog> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderLog {
  OrderLog({
    this.orderLogId = 0,
    this.fkOrderId = 0,
    this.message = "",
    required this.dateAdded,
    this.stringDate = "",
  });

  int orderLogId;
  int fkOrderId;
  String message;
  DateTime dateAdded;
  String stringDate;

  factory OrderLog.fromJson(Map<String, dynamic> json) => OrderLog(
    orderLogId: json["orderLogId"],
    fkOrderId: json["fkOrderId"],
    message: json["message"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    stringDate: json["stringDate"],
  );

  Map<String, dynamic> toJson() => {
    "orderLogId": orderLogId,
    "fkOrderId": fkOrderId,
    "message": message,
    "dateAdded": dateAdded.toIso8601String(),
    "stringDate": stringDate,
  };
}
