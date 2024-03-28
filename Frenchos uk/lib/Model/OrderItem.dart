// To parse this JSON data, do
//
//     final orderItem = orderItemFromJson(jsonString);

import 'dart:convert';

import 'Item.dart';
import 'ItemVerity.dart';

List<OrderItem> orderItemFromJson(String str) => List<OrderItem>.from(json.decode(str).map((x) => OrderItem.fromJson(x)));

String orderItemToJson(List<OrderItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderItem {
  OrderItem({
    this.orderItemId =0,
    this.fkOrderId= 0,
    this.fkItemId = 0,
    this.fkVerityId =0,
    this.qty = 0,
    this.item,
    this.itemVerities,
    this.itemInstruction = "",
  });

  int orderItemId;
  int fkOrderId;
  int fkItemId;
  int fkVerityId;
  int qty;
  Item? item;
  List<ItemVerity>? itemVerities;
  String itemInstruction;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    orderItemId: json["orderItemId"],
    fkOrderId: json["fkOrderId"],
    fkItemId: json["fkItemId"],
    fkVerityId: json["fkVerityId"],
    qty: json["qty"],
    itemInstruction: json["itemInstruction"],
    item: Item.fromJson(json["item"]),
    itemVerities: List<ItemVerity>.from(json["itemVerities"].map((x) => ItemVerity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderItemId": orderItemId,
    "fkOrderId": fkOrderId,
    "fkItemId": fkItemId,
    "fkVerityId": fkVerityId,
    "qty": qty,
    "itemInstruction": itemInstruction,
  };
}
