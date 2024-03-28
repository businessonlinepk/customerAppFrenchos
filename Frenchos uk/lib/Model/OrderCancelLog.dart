// To parse this JSON data, do
//
//     final orderCancelLog = orderCancelLogFromJson(jsonString);

import 'dart:convert';

OrderCancelLog orderCancelLogFromJson(String str) => OrderCancelLog.fromJson(json.decode(str));

String orderCancelLogToJson(OrderCancelLog data) => json.encode(data.toJson());

class OrderCancelLog {
  OrderCancelLog({
    this.orderCancelLogId = 0,
    this.fkOrderId = 0,
    this.message = "",
    required this.dateAdded,
  });

  int orderCancelLogId;
  int fkOrderId;
  String message;
  DateTime dateAdded;

  factory OrderCancelLog.fromJson(Map<String, dynamic> json) => OrderCancelLog(
    orderCancelLogId: json["orderCancelLogId"],
    fkOrderId: json["fkOrderId"],
    message: json["message"],
    dateAdded: DateTime.parse(json["dateAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "orderCancelLogId": orderCancelLogId,
    "fkOrderId": fkOrderId,
    "message": message,
    "dateAdded": dateAdded.toIso8601String(),
  };
}
