import 'dart:convert';
import 'Item.dart';
import 'ItemVerity.dart';

List<CountItem> countItemFromJson(String str) => List<CountItem>.from(json.decode(str).map((x) => CountItem.fromJson(x)));

String countItemToJson(List<CountItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountItem {
  CountItem({
    required this.orderItemId,
   required this.fkOrderId,
   required this.fkItemId,
   required this.fkVerityId,
   required this.itemInstruction,
   required this.qty,
   required this.item,
   required this.itemVerity,
  });

  int orderItemId;
  int fkOrderId;
  int fkItemId;
  int fkVerityId;
  String itemInstruction;
  int qty;
  Item? item;
  ItemVerity? itemVerity;

  factory CountItem.fromJson(Map<String, dynamic> json) => CountItem(
    orderItemId: json["orderItemId"],
    fkOrderId: json["fkOrderId"],
    fkItemId: json["fkItemId"],
    fkVerityId: json["fkVerityId"],
    itemInstruction: json["itemInstruction"],
    qty: json["qty"],
    item: Item.fromJson(json["item"]),
    itemVerity: ItemVerity.fromJson(json["itemVerity"]),
  );

  Map<String, dynamic> toJson() => {
    "orderItemId": orderItemId,
    "fkOrderId": fkOrderId,
    "fkItemId": fkItemId,
    "fkVerityId": fkVerityId,
    "itemInstruction": itemInstruction,
    "qty": qty,
    "item": item!.toJson(),
    "itemVerity": itemVerity!.toJson(),
  };
}

/*
class Items {
  Items({
    required this.itemId,
    required this.fkRestaurantId,
    required this.fkCategoryId,
    required this.name,
    required this.description,
    required this.imgUrl,
    required this.price,
    required this.tax,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.dateAdded,
    required this.restaurant,
    required this.categry,
  });

  int itemId;
  int fkRestaurantId;
  int fkCategoryId;
  String name;
  String description;
  String imgUrl;
  int price;
  int tax;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Restaurant restaurant;
  Categry categry;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    itemId: json["itemId"],
    fkRestaurantId: json["fkRestaurantId"],
    fkCategoryId: json["fkCategoryId"],
    name: json["name"],
    description: json["description"],
    imgUrl: json["imgUrl"],
    price: json["price"],
    tax: json["tax"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
    categry: Categry.fromJson(json["categry"]),
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "fkRestaurantId": fkRestaurantId,
    "fkCategoryId": fkCategoryId,
    "name": name,
    "description": description,
    "imgUrl": imgUrl,
    "price": price,
    "tax": tax,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "restaurant": restaurant.toJson(),
    "categry": categry.toJson(),
  };
}
*/

/*class Categry {
  Categry({
    required this.categoryId,
    required this.fkMenuId,
    required this.name,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.dateAdded,
    required this.menu,
  });

  int categoryId;
  int fkMenuId;
  String name;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Menu menu;

  factory Categry.fromJson(Map<String, dynamic> json) => Categry(
    categoryId: json["categoryId"],
    fkMenuId: json["fkMenuId"],
    name: json["name"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    menu: Menu.fromJson(json["menu"]),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "fkMenuId": fkMenuId,
    "name": name,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "menu": menu.toJson(),
  };
}

class Menu {
  Menu({
    required this.menuId,
    required this.fkRestaurantId,
    required this.name,
    required this.description,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.dateAdded,
    required this.monStart,
    required this.monEnd,
    required this.tueStart,
    required this.tueEnd,
    required this.wedStart,
    required this.wedEnd,
    required this.thrStart,
    required this.thrEnd,
    required this.friStart,
    required this.friEnd,
    required this.satStart,
    required this.satEnd,
    required this.sunStart,
    required this.sunEnd,
    required this.restaurant,
  });

  int menuId;
  int fkRestaurantId;
  String name;
  String description;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  DateTime monStart;
  DateTime monEnd;
  DateTime tueStart;
  DateTime tueEnd;
  DateTime wedStart;
  DateTime wedEnd;
  DateTime thrStart;
  DateTime thrEnd;
  DateTime friStart;
  DateTime friEnd;
  DateTime satStart;
  DateTime satEnd;
  DateTime sunStart;
  DateTime sunEnd;
  Restaurant restaurant;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    menuId: json["menuId"],
    fkRestaurantId: json["fkRestaurantId"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    monStart: DateTime.parse(json["monStart"]),
    monEnd: DateTime.parse(json["monEnd"]),
    tueStart: DateTime.parse(json["tueStart"]),
    tueEnd: DateTime.parse(json["tueEnd"]),
    wedStart: DateTime.parse(json["wedStart"]),
    wedEnd: DateTime.parse(json["wedEnd"]),
    thrStart: DateTime.parse(json["thrStart"]),
    thrEnd: DateTime.parse(json["thrEnd"]),
    friStart: DateTime.parse(json["friStart"]),
    friEnd: DateTime.parse(json["friEnd"]),
    satStart: DateTime.parse(json["satStart"]),
    satEnd: DateTime.parse(json["satEnd"]),
    sunStart: DateTime.parse(json["sunStart"]),
    sunEnd: DateTime.parse(json["sunEnd"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "fkRestaurantId": fkRestaurantId,
    "name": name,
    "description": description,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "monStart": monStart.toIso8601String(),
    "monEnd": monEnd.toIso8601String(),
    "tueStart": tueStart.toIso8601String(),
    "tueEnd": tueEnd.toIso8601String(),
    "wedStart": wedStart.toIso8601String(),
    "wedEnd": wedEnd.toIso8601String(),
    "thrStart": thrStart.toIso8601String(),
    "thrEnd": thrEnd.toIso8601String(),
    "friStart": friStart.toIso8601String(),
    "friEnd": friEnd.toIso8601String(),
    "satStart": satStart.toIso8601String(),
    "satEnd": satEnd.toIso8601String(),
    "sunStart": sunStart.toIso8601String(),
    "sunEnd": sunEnd.toIso8601String(),
    "restaurant": restaurant.toJson(),
  };
}

class Restaurant {
  Restaurant({
    required this.restaurantId,
    required this.fkCityId,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.primaryContact,
    required this.secondaryContact,
    required this.logo,
    required this.address,
    required this.landMark,
    required this.dateAdded,
    required this.isActive,
    required this.isDeleted,
  });

  int restaurantId;
  int fkCityId;
  String name;
  String ownerName;
  String email;
  String primaryContact;
  String secondaryContact;
  String logo;
  String address;
  String landMark;
  DateTime dateAdded;
  bool isActive;
  bool isDeleted;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurantId: json["restaurantId"],
    fkCityId: json["fkCityId"],
    name: json["name"],
    ownerName: json["ownerName"],
    email: json["email"],
    primaryContact: json["primaryContact"],
    secondaryContact: json["secondaryContact"],
    logo: json["logo"],
    address: json["address"],
    landMark: json["landMark"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "restaurantId": restaurantId,
    "fkCityId": fkCityId,
    "name": name,
    "ownerName": ownerName,
    "email": email,
    "primaryContact": primaryContact,
    "secondaryContact": secondaryContact,
    "logo": logo,
    "address": address,
    "landMark": landMark,
    "dateAdded": dateAdded.toIso8601String(),
    "isActive": isActive,
    "isDeleted": isDeleted,
  };
}

class ItemVerity {
  ItemVerity({
    required this.itemVerityId,
    required this.fkItemId,
    required this.name,
    required this.addPrice,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.dateAdded,
    required this.item,
  });

  int itemVerityId;
  int fkItemId;
  String name;
  int addPrice;
  bool status;
  bool isActive;
  bool isDeleted;
  DateTime dateAdded;
  Items item;

  factory ItemVerity.fromJson(Map<String, dynamic> json) => ItemVerity(
    itemVerityId: json["itemVerityId"],
    fkItemId: json["fkItemId"],
    name: json["name"],
    addPrice: json["addPrice"],
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    dateAdded: DateTime.parse(json["dateAdded"]),
    item: Items.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "itemVerityId": itemVerityId,
    "fkItemId": fkItemId,
    "name": name,
    "addPrice": addPrice,
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "dateAdded": dateAdded.toIso8601String(),
    "item": item.toJson(),
  };
}*/
