
import 'dart:convert';

import 'package:http/http.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/Model/Banner.dart';
import 'package:yoracustomer/Model/CustomerAddress.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudStore;
import 'package:cloud_firestore/cloud_firestore.dart' as cloudfare;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yoracustomer/Model/Restaurant.dart';
import 'package:yoracustomer/LinkFiles/EndPoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoracustomer/Services/SendNotificationMessageApi.dart';
import '../Model/BykeaResponse.dart';
import '../Model/Categry.dart';
import '../Model/Customer.dart';
import '../Model/Delivery.dart';
import '../Model/Item.dart';
import '../Model/Order.dart';
import '../Model/OrderItem.dart';
import '../Model/OrderLog.dart';
import '../Model/RestaurantArea.dart';
import '../Model/Rider.dart';
import '../Model/VerityGroup.dart';
import '../Services/ApiResponse.dart';
import '../Services/ApiService.dart';

class itemscontroller {

  Future<int> updateBooking(int orderId, String status) async {
    http.Response response = await http.get(
      Uri.parse("${EndPoints.apiPath}Bykea/UpdateBooking?orderId=$orderId&status=$status"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    return response.statusCode;
  }
  Future<Item> getUser(int? itemId) async {
    var headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      Uri.parse(EndPoints.apiPath+"Items/detail/"+itemId.toString()),
      headers: headers,
    );

    // print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Item user = Item.fromJson(data);
      return user;
    } else {
      // print(response.body);
      throw Exception('Failed');
    }
  }

  // Future<List<OrderItem>?> orderItems(int oid)  async {
  //   ApiResponse res = ApiResponse();
  //   ApiService apiService = ApiService();
  //   res = await apiService.GetData(EndPoints.apiPath+"Orders/OrderItems/2");
  //   if (res.StatusCode == 0) {
  //   } else if (res.StatusCode == 200) {
  //     List data = res.Response;
  //     print("Datahhhh print : :::::"+data.toString());
  //     List<OrderItem> Items = data.map<OrderItem>((json) => OrderItem.fromJson(json)).toList();
  //     // print(Items);
  //
  //     //orders = orderFromJson(data.toString());
  //
  //     // List<Order> o = orderFromJson(data.toString());
  //     //print("Next line::::"+orders[0].dateAdded.toString());
  //     //print("Next line::::");
  //     return Items;
  //   }
  // }
  Future<Item>  quantity(String customerid) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var id = prefs.getInt('id');
    // var token = prefs.getString('token');
    // var url = '$baseUrl/users/$id';
    var headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      Uri.parse(EndPoints.apiPath+"Items/detail/"+customerid),
      headers: headers,
    );

    // print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Item user = Item.fromJson(data);
      return user;
    } else {
      // print(response.body);
      throw Exception('Failed');
    }
  }


  Future<List<Item>?> Getcount(String customerid,int ctid)  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    // print(EndPoints.apiPath+"Items?rid=5&cid="+ctid.toString());
    res = await apiService.GetData(EndPoints.apiPath+"Items?rid=5&cid="+ctid.toString());
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      // print("Data print : :::::"+data.toString());
      List<Item> ItemDatas = data.map<Item>((json) => Item.fromJson(json)).toList();
      //orders = orderFromJson(data.toString());
      // List<Order> o = orderFromJson(data.toString());
      //print("Next line::::"+orders[0].dateAdded.toString());
      //print("Next line::::");
      return ItemDatas;
    }
  }

  Future<Order?> createorder(String customerid,String rid, int pid, String instruction)  async {

    var url = EndPoints.apiPath+"Orders/Create?rid="+rid+"&cid="+ customerid+"&pid="+pid.toString() +"&itemInstruction=" + instruction;

    Order? order;
    // print(url);
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (res.statusCode == 200) {
      // print("Ok");
      var data = res.body;
      order = Order.fromJson(jsonDecode(data));
    }
    return order;

  }

  Future<List<OrderItem>?> OrderItems()  async {

    Order orderdetail = await itemscontroller().orderDetailsMethod(Globle.OrderId.toString());
    print(Globle.OrderId.toString()+"order id ");
    if(orderdetail.orderStatus != 'c')
    {
      ApiResponse res = ApiResponse();
      ApiService apiService = ApiService();
      res = await apiService.GetData(EndPoints.apiPath+"Orders/OrderItems/"+Globle.OrderId.toString());
      print(EndPoints.apiPath+"Orders/OrderItems/"+Globle.OrderId.toString());
      print(res.StatusCode);
      if (res.StatusCode == 0) {
      } else if (res.StatusCode == 200) {
        List data = res.Response;
        List<OrderItem> ItemDatas = data.map<OrderItem>((json) => OrderItem.fromJson(json)).toList();
        return ItemDatas;
      }
    }


  }

  Future<int> GetOrderId(BuildContext context)  async {

    if(Globle.customerid > 0)
      {
        http.Response res = await http.get(
          Uri.parse(EndPoints.apiPath+"Orders/GetOrderId?rid="+EndPoints.Resturantid.toString()+"&cid=" + Globle.customerid.toString()),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
        );
        if (res.statusCode == 200) {

          Globle.OrderId = int.parse(res.body);
          if(Globle.OrderId > 0) {
            Order orderdetail = await itemscontroller().orderDetailsMethod(Globle.OrderId.toString());
            if(orderdetail.orderId > 0)
            {
              if(orderdetail.orderStatus != 'd' && orderdetail.orderStatus != 'c')
              {
                Globle.OrderGenerated = orderdetail.orderGenrated;
                if(Globle.OrderId > 0 && Globle.OrderGenerated)
                {
                  /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId)));*/
                  return 1;
                }
                else{
                  return 0;
                }
              }

            }
          }
        }
      }
    return 0;
  }

  Future<List<OrderItem>?> countbadge(String oid)  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"Orders/OrderItems/"+oid.toString());
    // print(res.StatusCode);
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      // print("usman print : :::::"+data.toString());
      List<OrderItem> CountItemDatas = data.map<OrderItem>((json) => OrderItem.fromJson(json)).toList();
      //orders = orderFromJson(data.toString());
      // List<Order> o = orderFromJson(data.toString());
      //print("Next line::::"+orders[0].dateAdded.toString());
      //print("Next line::::");
      return CountItemDatas;
    }


  }

  Addcount(int itemId)  async {
    print("uuuuuuuuuuuuuuuuuuuuu");
    http.Response res = await http.post(
      Uri.parse(EndPoints.apiPath+"Orders/addItemQty?oid="+Globle.OrderId.toString()+"&pid="+itemId.toString()),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    // print(EndPoints.apiPath+"Orders/addItemQty?oid="+Globle.OrderId.toString()+"&pid="+Globle.ProductId.toString());
    if (res.statusCode == 200) {
      print("Ok");
      // var data = res.body;
    }

  }

  Minuscount(int itemId)  async {
    print("${EndPoints.apiPath}Orders/subtractItemQty?oid=${Globle.OrderId}&pid=$itemId");
    http.Response res = await http.post(
      Uri.parse("${EndPoints.apiPath}Orders/subtractItemQty?oid=${Globle.OrderId}&pid=$itemId"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (res.statusCode == 200) {
      print("Ok");
      // var data = res.body;
    }

  }
/*
  Future<List<ItemVerity>?> Displayinstruction(int? itemId)  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"ItemVrities?Iid="+itemId.toString());
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      // print("Javed print : :::::"+data.toString());
      List<ItemVerity> ItemDatas = data.map<ItemVerity>((json) => ItemVerity.fromJson(json)).toList();

      return ItemDatas;
    }else if(res.StatusCode ==400){
      print(res.Response);
      // print("content");
    }
  }
*/

  Radiobuttoncheck(int pid, int vid,bool statuscheck)  async {
    print(pid);
    print(Globle.OrderId);
    http.Response res = await http.post(
      Uri.parse("${EndPoints.apiPath}Orders/addItemVerity?oid=${Globle.OrderId}&pid=$pid&vid=$vid&addCheck=$statuscheck"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    // print(EndPoints.apiPath+"Orders/addItemVerity?oid="+Globle.OrderId.toString()+"&pid="+pid.toString()+"&vid="+vid.toString()+"&addCheck="+statuscheck.toString());
    if (res.statusCode == 200) {
      // var data = res.body;
      print("success");
    }else if(res.statusCode == 201){
      print("removed");
    }
    else
    {
      print("error");
    }
  }
  Future<Order> orderDetailsMethod(String orderId)  async {
    Order order = Order( preparationTime: DateTime.now(),dateAdded: DateTime.now(), dispatchTime: DateTime.now(), deliveryTime: DateTime.now(),customer: Customer(dateAdded: DateTime.now()));

    print("dddddddd"+"${EndPoints.apiPath}Orders/Detail/${Globle.OrderId}?&rid=${EndPoints.Resturantid}");

    http.Response res = await http.get(
      Uri.parse("${EndPoints.apiPath}Orders/Detail/${Globle.OrderId}?&rid=${EndPoints.Resturantid}"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    print(res.body);
    if (res.statusCode == 200) {
      var data = res.body;
      order = Order.fromJson(jsonDecode(data));
    }
    return order;

  }

  Future<Order> orderFinalDetail(String orderId)  async {
    Order order = Order( preparationTime: DateTime.now(),dateAdded: DateTime.now(), dispatchTime: DateTime.now(), deliveryTime: DateTime.now(),customer: Customer(dateAdded: DateTime.now()));
    http.Response res = await http.get(
      Uri.parse("${EndPoints.apiPath}Orders/FinalDetail/${Globle.OrderId}?&rid=${EndPoints.Resturantid}"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    print("${EndPoints.apiPath}Orders/FinalDetail/${Globle.OrderId}?&rid=${EndPoints.Resturantid}");
    print(res.body);
    if (res.statusCode == 200) {
      var data = res.body;
      order = Order.fromJson(jsonDecode(data));
    }
    return order;

  }

  Future<int> GenerateOrders(String type, String instruction)  async  {
    print("GenerateOrders hit---------------------->, \n Generate Order is generating a new order");
    instruction = Globle.instruction;
    var url =  "${EndPoints.apiPath}Orders/GenerateOrder/${Globle.OrderId}?paymentType=$type&instrutions=$instruction";
    // var url =  "${EndPoints.apiPath}Orders/GenerateOrder/${Globle.OrderId}?paymentType=$type&instrutions=$instruction";
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (res.statusCode == 200) {
      print("New Order Generated Successfully");
      Order? order;
      //Passing Order Id in String "order" to send new order notification to Operator
      order = await orderFinalDetail(Globle.OrderId.toString());
      ///Commenting out and moving "sending notfication to operator" to "proceed" button
      ///because here it's going in a loop.
      ///Also renaming it to StoringOrderInfoToFirebase
      StoringOrderInfoToFirebase(order);
      Globle.OrderGenerated = true;
      Globle.instruction = "";
    }
    return res.statusCode;
  }

  ///The notifications are being sent with this function to send New order notification to Operator App---------->
  ///TODO: To Operator app when Order is generated,
  ///order which this function is getting from above function got the details of the order

  ///RestaurantId for Operator will always be zero "0" because it's set to zero in firebase and is set that way.
  Future<void> StoringOrderInfoToFirebase(Order? order) async {
    print("SendNewOrderNotificationToOperator is Hit to send New order notification to Operator App---------->");
    String ownerToken = "";//"djCO1jF0RfOW89peodjMK-:APA91bHNjsRXuKC5ckmObyqiF9cZyGWqCyZvO0EADdaEGrXKm3xDhNIdxi6zQaVUmaFQ1RfpK4JnpattizT5Tl86mK8c2EgtpIp_MTU5VGXJuHKgWRfgeLZn6L7eiXcnkvmghhybG_nM";
    /*cloudStore.FirebaseFirestore.instance
        .collection("Employees").where("fkRestaurantId", isEqualTo: int.parse(EndPoints.Resturantid.toString()))
        .get()
        .then((cloudStore.QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        sendPushMessage(doc['token'], "Alert", "New order received", "notification");
        if(doc['userType'] == 'o')
        {
          ownerToken = doc['token'];
        }
      });
    });*/
    cloudStore.FirebaseFirestore.instance
        .collection("Employees").where("fkRestaurantId", isEqualTo: 0)
        .get()
        .then((cloudStore.QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        ///New
        // SendMessageApi().sendMessage(receiverToken, notificationBody,
        //     notificationTitle, notificationPayloadType, notificationPayloadMessage)
        // SendMessageApi().sendMessage(doc['token'], "New Order just received",
        //     "New Order", "New Order", "notification");
        //Original / Old
        // sendPushMessage(token, title, body, data)
        // sendPushMessage(doc['token'], "Alert", "New order received", "notification",);
        if(doc['userType'] == 'o')
        {
          ownerToken = doc['token'];
        }
      });
    });
    //sendPushMessage(ownerToken, "Alert", "You just received a new order", "notification");
    if(order != null)
    {
      await cloudStore.FirebaseFirestore.instance
          .collection("Orders")
          .doc(order.orderId.toString())
          .set({
        "paymentHolder": order.paymentHolder,
        "paymentType": order.paymentType,
        "orderStatus": order.orderStatus,
        "riderToken": "",
        "restaurantToken" : ownerToken,
        "customerToken": Globle.token,
      });
    }
/*    await cloudStore.FirebaseFirestore.instance
        .collection("Customers")
        .doc(Globle.customerid.toString())
        .set({
      "id": Globle.customerid.toString(),
      "token": Globle.token,
    });*/
  }

  ///Sending New Order Notification to Operator, this is sending notifiaation to both operator and owner
  ///TODO:
  Future<void>SendNotificationToOperator() async {
    //Below in .where("fkRestaurantId", isEqualTo: EndPoints.Resturantid) it was "EndPoints.Resturantid"
    // but in Firebase the operator Restaurantid is 0 so 0 is correct else revert to original which is in this comment at the start at ".where"
    try {
      String operatorToken = "";
      int i = 0;
      cloudfare.FirebaseFirestore.instance
          .collection("Employees")
          .where("fkRestaurantId", isEqualTo: EndPoints.Resturantid)
          .get()
          .then((cloudfare.QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          if (doc['userType'] == 'x') {
            operatorToken = doc['token'];
            i++;
            print("Operator Token found in Doc $i from Firebase => $operatorToken");
         // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
         //     notificationPayloadType, notificationPayloadMessage, receiverChannelId, resId)
            SendMessageApi().sendMessage(
                operatorToken, "New Order Received, Please Check", "New Order Alert",
                "New Order", "New Order Notification message from YORA", "restaurantAdmin1", EndPoints.Resturantid.toString());

            print("userType == 'x' found in $i doc in collection(Employees) where(fkRestaurantId, isEqualTo: EndPoints.Resturantid)");
          } else if (doc['userType'] == 'o') {
            i++;
            print("userType == 'x' not found in $i doc in collection(Employees) where(fkRestaurantId, isEqualTo: EndPoints.Resturantid)");
          }
        });
      });
    } catch (e) {print("Error Sending Notification to Operator App => $e");}
  }

  ///Commented out because this is sending notifiaation to both operator and owner
//   Future<void>SendNotificationToOperator() async {
//     cloudStore.FirebaseFirestore.instance
//         .collection("Employees").where("fkRestaurantId", isEqualTo: EndPoints.Resturantid)
//         .get()
//         .then((cloudStore.QuerySnapshot snapshot) {
//           //forEach loop used to send notification to all RestaurantId tokens.
//       snapshot.docs.forEach((doc) {
//         print("Operator Token to send New Order => ${doc['token']}");
//         // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
//         //     notificationPayloadType, notificationPayloadMessage, receiverChannelId)
//         SendMessageApi().sendMessage(doc['token'], "New Order Alert, Please Check",
//             "New Order Alert", "New Order", "New Order Payload Message", "restaurantAdmin1", EndPoints.Resturantid.toString());
//       });
//     });
//   }

  Future<Customer?> GetProfileCustomer()  async {
    Customer? order;
    http.Response res = await http.get(
      Uri.parse("${EndPoints.apiPath}Customers/GetUser/${Globle.customerid}"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (res.statusCode == 200) {
      var data = res.body;
      order = Customer.fromJson(jsonDecode(data));
    }
    return order;

  }
  Future<int> UpdateCustomer(Customer customer) async {
        String? body = json.encode(customer.toJson());
        print(body);
    http.Response response = await http.post(
    Uri.parse("${EndPoints.apiPath}Customers/UpdateCustomer"),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: body,
    );
return response.statusCode;
  }
  /*UpdateCustomer(String name,email,address,contact,landmark) async {
    final response = await http.post(Uri.parse(EndPoints.apiPath+"Customers/UpdateCustomer"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
        body:  jsonEncode(<String, dynamic>{
          "customerId": Globle.customerid,
          "fkCityId": "0",
          "fkRestaurantId": EndPoints.Resturantid,
          "name": name,
          "email": email,
          "contact":contact,
          "address":address,
          "landmark": landmark,
          "dateAdded": "2022-12-27T16:14:42.8340933",
          "isActive": true,
          "isDeleted": false,
        },
        ).toString());
    if (response.statusCode == 200) {
      // print(response.body);
    } else {
      throw Exception('Failed to create user.');
    }
  }*/
  Future<List<OrderItem>?> cartApi()  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData("${EndPoints.apiPath}Orders/OrderItems/${Globle.OrderId}");
    print("${EndPoints.apiPath}Orders/OrderItems/${Globle.OrderId}");
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      List<OrderItem> countItemData = data.map<OrderItem>((json) => OrderItem.fromJson(json)).toList();
      return countItemData;
    }
    return null;
  }


  Future<List<Categry>> getMenu() async {
    List<Categry> categories = [];
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData("${EndPoints.apiPath}Categories?mid=0&rid=${EndPoints.Resturantid}");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(res.StatusCode == 200){
      List data = res.Response;
      List<Categry> categories = data.map<Categry>((json) => Categry.fromJson(json)).toList();

      List<String> categoryJsonList = categories.map((category) => json.encode(category.toJson())).toList();
      await preferences.setStringList("categories", categoryJsonList);
    }
    else{
      await preferences.remove("categories");
    }
    return categories;
  }

  Future<List<Order>?> Userhistory()  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();res = await apiService.GetData(EndPoints.apiPath+"Customers/Orders?cid="+Globle.customerid.toString());
    //print(res.StatusCode);
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      // print("rashid0435 : :::::"+data.toString());
      List<Order> ItemDatas = data.map<Order>((json) => Order.fromJson(json)).toList();
      //orders = orderFromJson(data.toString());
      // List<Order> o = orderFromJson(data.toString());
      // print("Next line::::"+orders[0].dateAdded.toString());
      //print("Next line::::");
      return ItemDatas;
    }
  }

///Original commented out.
  // void requestPermission() async {
  //
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print("Permission granted");
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print("Provisional Permission granted");
  //   } else {
  //     print("User denied");
  //   }
  // }

///Example code of Notification send api
  // Future<void> sendMessage(String token, String bodye,String title, String type) async {
  //   print("Sending notification...");
  //
  //   final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //
  //   ///TODO: we need to set Header as below and paste Authorization key from Firebase.
  //   ///Change to new key before applying to different FireBase
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=AAAAmWSPeyc:APA91bGVVtv0jW67rWUl-UIRoaIPPQggwvDJBvNGzVVacooQrB3Q1APpGSlwNeTAS8Yux7IGFLjWePpmrJDRvWHWUP0u5xkeVlyMNW3rZWYp1DxwbtxL2c8xSaBHR7okbptKddR1rxmA',
  //   };
  //
  //   ///TODO: This is the body data which will be converted to JSON and then stored in a variable and assigned to below response.
  //
  //   Map<String, dynamic> body = {
  //     "to": token.toString(),
  //     "notification": {
  //       "body": bodye.toString(),
  //       "title": title.toString(),
  //       "android_channel_id": "pushnotificationapp3",
  //       "sound": true,
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //     },
  //     "data": {
  //       "type": type,
  //       "_id": "payload",
  //     },
  //   };
  //
  //   ///TODO: Printing all information which is in body.
  //   print("Printing all notification sending information which is in body => \n $body");
  //
  //   String jsonBody = json.encode(body);
  //   final encoding = Encoding.getByName('utf-8');
  //
  //   ///Post API
  //   Response response = await post(
  //     uri,
  //     headers: headers,
  //     body: jsonBody,
  //     encoding: encoding,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("Notification sent successfully.----------------------------------->");
  //   } else {
  //     print("Failed to send notification. Status code: ${response.statusCode}");
  //   }
  // }
///Todo New sendPushMessage






  ///Original sendPushMessage Backup
  // void sendPushMessage(String token, String title, String body, var data) async {
  //
  //   /*FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   await firebaseMessaging.sendMessage(to: token,data: data);*/
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': Globle.NotificationKey
  //       },
  //       body: jsonEncode(
  //           <String, dynamic>{
  //             'priority':'high',
  //             'data':<String,dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'status':'done',
  //               'body':body,
  //               'title': title,
  //               'data': data
  //             },
  //
  //             'notification': <String,dynamic>{
  //               "title":title,
  //               "body":body,
  //               "android_channel_id": "restaurantAdmin"
  //             },
  //             "to": token,
  //           }
  //       ),
  //     );
  //     print(" notification sent to Haroon");
  //   } catch (e) {
  //     print("notification not sent");
  //   }
  // }


  /* void saveOrderToFB(Order order) async {
    await cloudStore.FirebaseFirestore.instance
        .collection("Orders")
        .doc(Globle.OrderId..toString())
        .update({
      "token": token,
    });
    print("token saved");
  }*/

///
  ///TODO: To Employees, for Chat
  Future<void> msgNotification(
      String msg, String heading, String token, String type) async {
    print("sendNotification");
    String ownerToken =
        ""; //"djCO1jF0RfOW89peodjMK-:APA91bHNjsRXuKC5ckmObyqiF9cZyGWqCyZvO0EADdaEGrXKm3xDhNIdxi6zQaVUmaFQ1RfpK4JnpattizT5Tl86mK8c2EgtpIp_MTU5VGXJuHKgWRfgeLZn6L7eiXcnkvmghhybG_nM";
    ///type == "e" means Restaurant
    if (type == "e" ) {
      cloudStore.FirebaseFirestore.instance
          .collection("Employees")
          .where("fkRestaurantId",
              isEqualTo: int.parse(EndPoints.Resturantid.toString()))
          .get()
          .then((cloudStore.QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          print("Employee token " + doc['token']);
          ///New
          ///The String 'heading' has New Message so it's not needed to define the type of New Message.
          // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
          //     notificationPayloadType, notificationPayloadMessage, receiverChannelId)
          SendMessageApi().sendMessage(doc['token'], msg,
              heading, "New Message", msg, "restaurantAdmin2", "");
          //Original / Old
          // sendPushMessage(token, title, body, data)
          // sendPushMessage(
          //     doc['token'], heading, msg, "tune3",);
          if (doc['userType'] == 'o') {
            print(doc['token']);
            ownerToken = doc['token'];
          }
        });
      });
    }
    ///type == "x" means Operator
    else if (type == "x") {
      cloudStore.FirebaseFirestore.instance
          .collection("Employees")
          .where("fkRestaurantId",
          isEqualTo: EndPoints.Resturantid)
          .get()
          .then((cloudStore.QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          ///New
          // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
          //     notificationPayloadType, notificationPayloadMessage, receiverChannelId)
          ///The String 'heading' has New Message so it's not needed to define the type of New Message
          SendMessageApi().sendMessage(doc['token'], msg,
              heading, "New Message", "", "restaurantAdmin2", "");
          //Original/ Old
          // sendPushMessage(token, title, body, data)
          // sendPushMessage(
          //     doc['token'], heading, msg,"",);
        });
      });
    }
    else{
      ownerToken = token;
      ///New
      // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
      //     notificationPayloadType, notificationPayloadMessage, receiverChannelId)
      SendMessageApi().sendMessage(ownerToken, msg,
          heading, "New Message", msg, "restaurantAdmin2", "");
      /// Original
      ///The String 'heading' has New Message so it's not needed to define the type of New Message
      // sendPushMessage(token, title, body, data)
      // sendPushMessage(ownerToken, heading, msg, "tune3",);
    }
  }

  Future<int> updateOrderType(int oid, bool type) async {
    if (oid > 0) {
      http.Response res = await http.post(
        Uri.parse(EndPoints.apiPath+"Orders/UpdateOrderType/" + oid.toString() + "?&type=" +type.toString()),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      return res.statusCode;
    }
    return 0;
  }


  Future<void> sendGroupVerities(int pid,List<VerityGroup> vg) async {
    List<int> itemVerities = [];
    for(int i= 0 ; i < vg.length; i++)
    {
      itemVerities.add(vg[i].selectedRadioId);
    }
    print(itemVerities);
    var headers = {
      'Content-Type': 'application/json'
    };
    print(EndPoints.apiPath +'Orders/addRadioItemVerity?oid='+Globle.OrderId.toString()+'&pid='+pid.toString());
    var request = http.Request('POST', Uri.parse(EndPoints.apiPath +'Orders/addRadioItemVerity?oid='+Globle.OrderId.toString()+'&pid='+pid.toString()));
    request.body = json.encode(itemVerities);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<int> saveTokenToServer(String token) async {
    print("Saving Token to Server => $token");
    http.Response response = await http.get(
      Uri.parse("${EndPoints.apiPath}Restaurants/SaveToken?token=$token&userType=c&id=${Globle.customerid}"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
      return response.statusCode;
  }
  Future<int> saveTokenToServer1(String token) async {
    print("Saving Token to Server1 => $token");
    http.Response response = await http.get(
      Uri.parse("${EndPoints.apiPath}Customers/SaveToken?token=$token&id=${Globle.uniqueId}&rid=${EndPoints.Resturantid}"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    print("${EndPoints.apiPath}Customers/SaveToken?token=$token&id=${Globle.uniqueId}&rid=${EndPoints.Resturantid}");
      return response.statusCode;
  }
  Future<int> Selectdelivery(int did) async {
    print(EndPoints.apiPath+"Orders/selectDeliveryOption/"+Globle.OrderId.toString()+"?did="+did.toString());
    http.Response response = await http.get(
      Uri.parse(EndPoints.apiPath+"Orders/selectDeliveryOption/"+Globle.OrderId.toString()+"?did="+did.toString()),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return 200;
    }
    else {
      return 404;
    }
  }

  Future<Restaurant> getRestaurant() async {
    Restaurant restaurant = Restaurant(dateAdded: DateTime.now(),waitingTime: 30, from: DateTime.now(),to: DateTime.now());
print("${EndPoints.apiPath}Restaurants/GetUser/${EndPoints.Resturantid}");
      http.Response response = await http.get(
        Uri.parse("${EndPoints.apiPath}Restaurants/GetUser/${EndPoints.Resturantid}"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        restaurant = Restaurant.fromJson(jsonDecode(response.body));
        SharedPreferences preferences = await SharedPreferences.getInstance();
        try{
          String? user = preferences.getString("user");
          Customer customer = Customer.fromJson(jsonDecode(user!));
          customer.restaurant = restaurant;
        }catch(e){}


        String? res = json.encode(restaurant.toJson());
        preferences.setString("restaurant", res);
      }
    return restaurant;
  }
  
  Future<List<Delivery>> Getdeliveries()  async {
    List<Delivery> deliveries = [Delivery(dateAdded: DateTime.now())];
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"Orders/GetDeliveryOptions/"+EndPoints.Resturantid.toString()+"?oid="+Globle.OrderId.toString());
    print(res.StatusCode);
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      try{
        List data = res.Response;
        deliveries = data.map<Delivery>((json) => Delivery.fromJson(json)).toList();
      }
      catch(e){

      }
    }
    return deliveries;

  }


  Future<List<BannerModelS>> fetchBanners() async {
    final response = await http.get(Uri.parse(EndPoints.apiPath+"Banners/GetBanners/"+EndPoints.Resturantid.toString()));
    if (response.statusCode == 200) {
      return bannerModelSFromJson(response.body);
    } else {
      throw Exception('Failed to fetch banners');
    }
  }
  Future<Customer> getCustomer(String number) async {
    Customer customer = Customer(dateAdded: DateTime.now());

    // Assign the result of replaceAll back to the variable
    number = number.replaceAll("+", "");

    print("rshid ${EndPoints.apiPath}Customers/GetUserByNumber/$number?rid=${EndPoints.Resturantid}");

    if (number.isNotEmpty) {
      http.Response response = await http.get(
        Uri.parse("${EndPoints.apiPath}Customers/GetUserByNumber/$number?rid=${EndPoints.Resturantid}"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );

      if (response.statusCode == 200) {
        customer = Customer.fromJson(jsonDecode(response.body));
      }
    }

    return customer;
  }


  Future<int> updateprofile(Customer customer) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            EndPoints.apiPath +'Customers/UpdateCustomer'));
    request.body = jsonEncode(customer);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response.statusCode;
    /*if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      print(response.reasonPhrase);
    }*/
  }
// Future<List<Banner>?> fetchBanners()  async {
//   ApiResponse res = ApiResponse();
//   ApiService apiService = ApiService();res = await apiService.GetData(EndPoints.apiPath+"Banners/GetBanners/"+EndPoints.Resturantid.toString());
//   print(res.StatusCode);
//   if (res.StatusCode == 0) {
//   } else if (res.StatusCode == 200) {
//     final bannerData =bannerFromJson(res.Response);
//
//     // Print the name of each delivery and its associated restaurant
//     bannerData.forEach((delivery) {
//       print('Delivery: ${banner}');
//       print('Restaurant: ${delivery.restaurant.name}');
//       print('Restaurant logo URL: ${delivery.restaurant.logo}');
//     });
//     // List data = res.Response;
//     // print("rashid0435 : :::::"+data.toString());
//     // List<Banner> banners = data.map<Banner>((json) => Banner.fromJson(json)).toList();
//     // return banners;
//   }
// }

  Future<int> updateOrderStatus(int oid, String status) async {
    if (oid > 0) {
      http.Response res = await http.post(
        Uri.parse("${EndPoints.apiPath}Orders/UpdateOrderStatus/$oid?val=$status"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      OrderLog o = OrderLog(dateAdded: DateTime.now());
      o.fkOrderId = oid;
      ///TODO: Order Status Logs----------------------------------------------->
      if (res.statusCode == 200) {
        // /// New Orders
        // if(status == "x" ){
        //   o.message = "New Order from a Customer";
        // }
        // ///Customer Order for collection
        // else if(status == "0") {
        //   o.message = "Delivery Type : Customer Ordered for collection";
        // }
        // ///Customer Orders for Delivery
        // else if(status == "1") {
        //   o.message = "Delivery Type : Customer Order for Delivery";
        // }
        // /// Orders in progress
        // else if(status == "i") {
        //   o.message = "Rider & Restaurant has accepted, food is being prepared.";
        // }
        // ///Customer Orders in Pool, Both our and Bykea pool, Job in pool, if bykea accepts the order then hammad bhai will add the logs because not the webhooks are working
        // else if(status == "s") {
        //   o.message = "Customer Order in Pool";
        // }
        // ///Confirm from Sir Haroon at night
        // // ///Waiting for rider
        // // else if(status == "p") {
        // //   o.message = "Waiting for rider";
        // // }
        // ///Waiting for rider from Sir Haroon
        // else if(status == "w") {
        //   o.message = "Waiting for rider";
        // }
        // ///Orders on the way
        // else if(status == "o") {
        //   o.message = "Orders on the way";
        // }
        // // order status d ho aour d payment holder ho to d status ho ga matlab order completed.
        // ///Order delivered & Payment Settled, Order Completed
        // else if(status == "d") {
        //   o.message = "Order delivered & Payment Settled, Order Completed";
        // }
        ///Customer Cancelled the order
        if(status == "c") {
          o.message = "Customer cancelled the order";
        }
        // What is w
        // Remove bykeaTracking
        /// Order Status Logs End---------------------------------------------->

        int check = await addOrderLog(o);
        if(check == 200) {
          return 200;
        }
        else {
          return check;
        }
      }
      return 404;
    } else {
      return 201;
    }
  }


  Future<int> addOrderLog (OrderLog? o) async{
    if (o != null) {
      String? body = json.encode(o.toJson());
      http.Response response = await http.post(
        Uri.parse("${EndPoints.apiPath}Orders/AddOrderLog"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: body,
      );
      if (response.statusCode == 200) {
        return 200;
      }
      else {
        return 404;
      }
    }
    else {
      return 201;
    }
  }

  Future<int> addNewAddress (CustomerAddress customerAddress) async{

      String? body = json.encode(customerAddress.toJson());
      http.Response response = await http.post(
        Uri.parse("${EndPoints.apiPath}Customers/AddAddress"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: body,
      );
      return response.statusCode;

  }

  Future<Rider> getRiderByOrderId(int oid) async {
    Rider rider = Rider(dateAdded: DateTime.now(),dob:  DateTime.now());
    if (oid > 0) {
      http.Response response = await http.get(
        Uri.parse(EndPoints.apiPath+"Riders/GetRiderByOrderId/" + oid.toString()),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        rider = Rider.fromJson(jsonDecode(response.body));
      }
    }
    return rider;
  }

  Future<List<RestaurantArea>> getRestaurantAreas()  async {
    List<RestaurantArea> restaurantAreas = [];
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData("${EndPoints.apiPath}Areas/GetRestaurantAreas/${EndPoints.Resturantid}");
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      restaurantAreas = data.map<RestaurantArea>((json) => RestaurantArea.fromJson(json)).toList();
    }
    return restaurantAreas;
  }



}