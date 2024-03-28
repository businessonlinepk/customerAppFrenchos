// To parse this JSON data, do
//
//     final categorySubModel = categorySubModelFromJson(jsonString);

import 'dart:convert';

CategorySubModel categorySubModelFromJson(String str) => CategorySubModel.fromJson(json.decode(str));

String categorySubModelToJson(CategorySubModel data) => json.encode(data.toJson());

class CategorySubModel {
  CategorySubModel({
    required this.categoryId,
    required this.fkMenuId,
    required this.name,
  });

  int categoryId;
  int fkMenuId;
  String name;

  factory CategorySubModel.fromJson(Map<String, dynamic> json) => CategorySubModel(
    categoryId: json["categoryId"],
    fkMenuId: json["fkMenuId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "fkMenuId": fkMenuId,
    "name": name,
  };
}
