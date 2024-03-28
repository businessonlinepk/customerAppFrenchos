import 'dart:convert';
import 'Customer.dart';
import 'Restaurant.dart';

List<Order?>? orderFromJson(String str) => json.decode(str) == null ? [] : List<Order?>.from(json.decode(str)!.map((x) => Order.fromJson(x)));

String orderToJson(List<Order?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class Order {
  Order({

    this.orderId = 0,
    this.fkRestaurantId = 0,
    this.fkCustomerId = 0,
    this.fkDeliveryId = 0,
    this.orderGenrated = false,
    this.productsAmount = 0,
    this.deliveryCharges =0,
    this.instructions = "",
    this.tax = 0.0,
    this.discount = 0.0,
    this.paymentHolder = 'c',
    this.paymentType = 'c',
    this.orderStatus = 'p',
    required this.dateAdded,
    required this.dispatchTime,
    required this.deliveryTime,
    required this.preparationTime,
    this.orderType = false,
    required this.customer,
    this.restaurant,

    this.fkAcceptedById = 0,
    this.fkEmployeeId = 0,
    this.fkInProgressById = 0,
    this.fkCancelById = 0,

  });

  int orderId;
  int fkRestaurantId;
  int fkAcceptedById;
  int fkEmployeeId;
  int fkInProgressById;
  int fkCancelById;
  int fkCustomerId;
  int fkDeliveryId;
  bool orderGenrated;
  double productsAmount;
  double deliveryCharges;
  String instructions;
  double tax;
  double discount;
  String paymentHolder;
  String paymentType;
  String orderStatus;
  DateTime dateAdded;
  DateTime dispatchTime;
  DateTime deliveryTime;
  DateTime preparationTime;
  bool orderType;
  Customer customer;
  Restaurant? restaurant;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["orderId"],
    fkRestaurantId: json["fkRestaurantId"],
    fkAcceptedById: json["fkAcceptedById"],
    fkEmployeeId: json["fkEmployeeId"],
    fkInProgressById: json["fkInProgressById"],
    fkCancelById: json["fkCancelById"],
    fkCustomerId: json["fkCustomerId"],
    fkDeliveryId: json["fkDeliveryId"],
    orderGenrated: json["orderGenrated"],
    productsAmount: json["productsAmount"].toDouble(),
    deliveryCharges: json["deliveryCharges"].toDouble(),
    instructions: json["instructions"],
    tax: json["tax"].toDouble(),
    discount: json["discount"].toDouble(),
    paymentHolder: json["paymentHolder"],
    paymentType: json["paymentType"],
    orderStatus: json["orderStatus"],
    orderType: json["orderType"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    dispatchTime: DateTime.parse(json["dispatchTime"]),
    deliveryTime: DateTime.parse(json["deliveryTime"]),
    preparationTime: DateTime.parse(json["preparationTime"]),
    customer: Customer.fromJson(json["customer"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "fkRestaurantId": fkRestaurantId,
    "fkAcceptedById": fkAcceptedById,
    "fkEmployeeId": fkEmployeeId,
    "fkInProgressById": fkInProgressById,
    "fkCancelById": fkCancelById,
    "fkCustomerId": fkCustomerId,
    "fkDeliveryId": fkDeliveryId,
    "orderGenrated": orderGenrated,
    "productsAmount": productsAmount,
    "deliveryCharges": deliveryCharges,
    "instructions": instructions,
    "tax": tax,
    "discount": discount,
    "paymentHolder": paymentHolder,
    "paymentType": paymentType,
    "orderStatus": orderStatus,
    "orderType": orderType,
    "dateAdded": dateAdded.toIso8601String(),
    "dispatchTime": dispatchTime.toIso8601String(),
    "deliveryTime": deliveryTime.toIso8601String(),
    "preparationTime": preparationTime.toIso8601String(),
    /*"customer": customer!.toJson(),
    "restaurant": restaurant!.toJson(),*/
  };
}
