// To parse this JSON data, do
//
//     final orderCancelOption = orderCancelOptionFromJson(jsonString);

import 'dart:convert';

List<OrderCancelOption> orderCancelOptionFromJson(String str) => List<OrderCancelOption>.from(json.decode(str).map((x) => OrderCancelOption.fromJson(x)));

String orderCancelOptionToJson(List<OrderCancelOption> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderCancelOption {
  OrderCancelOption({
    this.orderCancelOptionId = 0,
    this.message = "",
    this.optionFor = true,
    required this.dateAdded,
  });

  int orderCancelOptionId;
  String message;
  bool optionFor;
  DateTime dateAdded;

  factory OrderCancelOption.fromJson(Map<String, dynamic> json) => OrderCancelOption(
    orderCancelOptionId: json["orderCancelOptionId"],
    message: json["message"],
    optionFor: json["optionFor"],
    dateAdded: DateTime.parse(json["dateAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "orderCancelOptionId": orderCancelOptionId,
    "message": message,
    "optionFor": optionFor,
    "dateAdded": dateAdded.toIso8601String(),
  };
}
