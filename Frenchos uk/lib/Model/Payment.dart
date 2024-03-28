// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

List<Payment> paymentFromJson(String str) => List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));

String paymentToJson(List<Payment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payment {
  Payment({
    this.tId = 0,
    this.fkSenderId = 0,
    this.sender = 'b',
    this.fkOrderId = 0,
    this.fkReceiverId = 0,
    this.receiver = 'x',
    this.fkBankAccountId = 0,
    this.imgUrl = "NotFound.png",
    required this.dateAdded,
  });

  int tId;
  int fkSenderId;
  String sender;
  int fkOrderId;
  int fkReceiverId;
  String receiver;
  int fkBankAccountId;
  String imgUrl;
  DateTime dateAdded;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    tId: json["tId"],
    fkSenderId: json["fkSenderId"],
    sender: json["sender"],
    fkOrderId: json["fkOrderId"],
    fkReceiverId: json["fkReceiverId"],
    receiver: json["receiver"],
    fkBankAccountId: json["fkBankAccountId"],
    imgUrl: json["imgUrl"],
    dateAdded: DateTime.parse(json["dateAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "tId": tId,
    "fkSenderId": fkSenderId,
    "sender": sender,
    "fkOrderId": fkOrderId,
    "fkReceiverId": fkReceiverId,
    "receiver": receiver,
    "fkBankAccountId": fkBankAccountId,
    "imgUrl": imgUrl,
    "dateAdded": dateAdded.toIso8601String(),
  };
}
