

 import 'dart:convert';
import 'package:yoracustomer/Controller/itemscontroller.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/BankAccount.dart';
import '../Model/Payment.dart';
import '../LinkFiles/EndPoints.dart';
import '../services/ApiResponse.dart';
import '../services/ApiService.dart';

import 'package:http/http.dart' as http;




class BankAccountsController{
  void saveToken (String token) async {
  itemscontroller().saveTokenToServer(token);
    await FirebaseFirestore.instance
        .collection("Customers")
        .doc(Globle.customerid.toString())
        .set({"token": token,"id":Globle.customerid.toString()});
  }

  Future<List<BankAccount>?> getBankAccounts() async {

    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"BankAccounts?userId="+EndPoints.Resturantid.toString()+"&userType=b");
    print(EndPoints.apiPath+"BankAccounts?userId=6&userType=b");
    if (res.StatusCode == 0) {} else if (res.StatusCode == 200) {
      List data = res.Response;
      List<BankAccount> bankAccounts = data.map<BankAccount>((json) =>
          BankAccount.fromJson(json)).toList();

      return bankAccounts;
    }
    return null;
  }

  Future<BankAccount> detailBankAccount(int? id) async {
    BankAccount account = BankAccount();
    if (id! > 0) {
      http.Response response = await http.get(

        Uri.parse(EndPoints.apiPath+"BankAccounts/Details/"+id.toString()),
        headers: {"Content-Type": "application/json; charset=UTF-8"},

      );
      if (response.statusCode == 200) {
        account = BankAccount.fromJson(jsonDecode(response.body));
        return account;
      }
    }
    return account;
  }

 Future<int> addPayment(Payment p, XFile? file) async {

    p.fkSenderId = int.parse(Globle.customerid.toString());
    p.sender = "c";
    p.fkOrderId = int.parse(Globle.OrderId.toString());
    if (p.fkSenderId > 0) {

      String? body = json.encode(p.toJson());
      http.Response response = await http.post(
        Uri.parse("${EndPoints.apiPath}BankAccounts/AddPayment"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: body,

      );
      if (response.statusCode == 200) {
        if(file != null)
        {
          Payment payment = Payment.fromJson(jsonDecode(response.body));
          int sc = await uploadImage(payment.tId, file);
        }
        return 200;
      }
      else {
        return response.statusCode;
      }
    }
    else {
      return 201;
    }
 }
//     // final prefs = await SharedPreferences.getInstance();
//     // final String? user = prefs.getString('user');
//     // Customer employee = Customer.fromJson(jsonDecode());
//     Customer.customerId = employee.customerId;
//     p.sender = employee.userType;
//
//         if (p.fkSenderId > 0) {
// String? body = json.encode(p.toJson());
//       http.Response response = await http.post(
//         Uri.parse(EndPoints.apiPath+"BankAccounts/AddPayment"),
//         headers: {"Content-Type": "application/json; charset=UTF-8"},
//         body: body,
//
//       );
//       if (response.statusCode == 200) {
//         if(file != null)
//         {
//           Payment payment = Payment.fromJson(jsonDecode(response.body));
//           int sc = await uploadImage(payment.tId, file);
//           print("Image status code "+sc.toString());
//         }
//         return 200;
//       }
//       else {
//         return response.statusCode;
//       }
//     }
//     else {
//       return 201;
//     }

///Commenting out awesome notifications, Not called anywhere
// void awesomeNotification(String title, String body ) {
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 10,
//             channelKey: "channelName",
//             title: title,
//             body: body,
//           customSound: 'assets/Tunes/notification.mp3',
//         ),
//     );
//   }
  }

  Future<int> uploadImage(int pid, XFile file) async {
    var request = http.MultipartRequest('POST', Uri.parse(EndPoints.apiPath+"BankAccounts/UploadImg?paymentId="+pid.toString()+"&rid="+EndPoints.Resturantid.toString()+"&file"));
    request.fields.addAll({
      'paymentId': pid.toString(),
      'rid': EndPoints.Resturantid.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return 200;
    }
    return 201;
  }

