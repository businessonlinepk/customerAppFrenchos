// To parse this JSON data, do
//
//     final bankAccount = bankAccountFromJson(jsonString);

import 'dart:convert';

List<BankAccount> bankAccountFromJson(String str) => List<BankAccount>.from(json.decode(str).map((x) => BankAccount.fromJson(x)));

String bankAccountToJson(List<BankAccount> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankAccount {
  BankAccount({
    this.tId = 0,
    this.fkUserId = 0,
    this.userType = 'b',
    this.bankName  = "",
    this.accountTitle = "",
    this.iban = "",
    this.tax = 0,
    this.instruction = "",
    this.isActive = false,

  });

  int tId;
  int fkUserId;
  String userType;
  String bankName;
  String accountTitle;
  String iban;
  String instruction;
  bool isActive;
  int tax;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
    tId: json["tId"],
    fkUserId: json["fkUserId"],
    userType: json["userType"],
    bankName: json["bankName"],
    accountTitle: json["accountTitle"],
    iban: json["iban"],
    instruction: json["instruction"],
    isActive: json["isActive"],
    tax: json["tax"],
  );

  Map<String, dynamic> toJson() => {
    "tId": tId,
    "fkUserId": fkUserId,
    "userType": userType,
    "bankName": bankName,
    "accountTitle": accountTitle,
    "iban": iban,
    "instruction": instruction,
    "isActive": isActive,
    "tax": tax,
  };
}
