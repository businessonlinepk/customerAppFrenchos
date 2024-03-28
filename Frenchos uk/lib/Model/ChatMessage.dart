import 'dart:convert';

List<ChatMessage> chatMessageFromJson(String str) => List<ChatMessage>.from(json.decode(str).map((x) => ChatMessage.fromJson(x)));

String chatMessageToJson(List<ChatMessage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatMessage {
  int messageId;
  int fkOrderId;
  int fkSenderId;
  String senderType;
  int fkReceiverId;
  String receiverType;
  bool readCheck;
  bool isDeleted;
  String message;
  DateTime dateAdded;
  String senderName;
  String receiverName;
  String stringDate;
  String restaurantName;

  ChatMessage({
    this.messageId = 0,
    this.fkOrderId = 0,
    this.fkSenderId = 0,
    this.senderType = 'c',
    this.fkReceiverId = 0,
    this.receiverType = 'x',
    this.readCheck = false,
    this.isDeleted = false,
    this.message = "",
    required this.dateAdded,
    this.senderName = "",
    this.receiverName = "",
    this.stringDate = "",
    this.restaurantName = "",
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json["messageId"],
    fkOrderId: json["fkOrderId"],
    fkSenderId: json["fkSenderId"],
    senderType: json["senderType"],
    fkReceiverId: json["fkReceiverId"],
    receiverType: json["receiverType"],
    readCheck: json["readCheck"],
    isDeleted: json["isDeleted"],
    message: json["message"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    senderName: json["senderName"],
    receiverName: json["receiverName"],
    stringDate: json["stringDate"],
    restaurantName: json["restaurantName"],
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "fkOrderId": fkOrderId,
    "fkSenderId": fkSenderId,
    "senderType": senderType,
    "fkReceiverId": fkReceiverId,
    "receiverType": receiverType,
    "readCheck": readCheck,
    "isDeleted": isDeleted,
    "message": message,
    "dateAdded": dateAdded.toIso8601String(),
    "senderName": senderName,
    "receiverName": receiverName,
    "stringDate": stringDate,
    "restaurantName": restaurantName,
  };
}
