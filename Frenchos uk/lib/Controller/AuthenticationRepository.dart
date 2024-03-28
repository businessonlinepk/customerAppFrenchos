import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudStore;
import 'package:http/http.dart' as http;
import 'package:yoracustomer/Model/FareEstimateResponse.dart' as fare;
import 'package:yoracustomer/Services/SendNotificationMessageApi.dart';
import '../LinkFiles/EndPoints.dart';
import '../Model/BykeaResponse.dart';
import 'itemscontroller.dart';

class AuthenticationRepository{
  Future<String> verifyPhoneNumber(String number)async {
    String num = "";
    var request = http.Request('GET', Uri.parse('${EndPoints.apiPath}Authentications/PhoneVerification/923$number'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200){
      num =  await response.stream.bytesToString();
    }else{
    }
    return num;
  }
  Future<BykeaResponse> trackBooking(String id, int orderId) async {
    BykeaResponse res = BykeaResponse(data: Data(), success: false);
    http.Response response = await http.get(
      Uri.parse("${EndPoints.trackBooking}$id&orderId=$orderId"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if(response.statusCode == 200){
      res = BykeaResponse.fromJson(jsonDecode(response.body));
    }
    return res;
  }
  ///This is getting Deliverycharges from our server which is getting it from bykea so there is a lag in response due to the long network route
  ///The solution is below
  // Future<fare.FareEstimateResponse> fareEstimate(int code,String pLat,String pLng,String dLat,String dLng) async {
  //   fare.FareEstimateResponse fareEstimateResponse = fare.FareEstimateResponse(data: fare.Data());
  //   http.Response response = await http.post(
  //     Uri.parse("${EndPoints.apiPath}Bykea/FareEstimate"),
  //     headers: {"Content-Type": "application/json; charset=UTF-8"},
  //     body: json.encode({
  //       "service_code": code,
  //       "customer": {
  //         "phone": "923111182121"
  //       },
  //       "pickup": {
  //         "lat": pLat,
  //         "lng": pLng
  //       },
  //       "dropoff": {
  //         "lat": dLat,
  //         "lng": dLng
  //       }
  //     }),
  //
  //   );
  //   if (response.statusCode == 200) {
  //     fareEstimateResponse = fare.FareEstimateResponse.fromJson(jsonDecode(response.body));
  //     return fareEstimateResponse;
  //   }
  //   return fareEstimateResponse;
  // }
  ///This is getting Delivery charges straight from Bykea Server so there is no delay in delivery charges response
  Future<fare.FareEstimateResponse> fareEstimate(int code, String pLat, String pLng, String dLat, String dLng) async {
    fare.FareEstimateResponse fareEstimateResponse = fare.FareEstimateResponse(data: fare.Data());
    var headers = {
      'x-api-customer-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlNjg4MDZlZS1hZDk4LTRlZTUtOWI2Zi05MjBkMjEyYmU1NjgiLCJpYXQiOjE2OTQxNzM5NzcuMTE0LCJ0eXBlIjoiY3VzdG9tZXIifQ.XdwSBlu8yQLdaCctCEiegqv29U6e9lOWnHB-Ac9Rt3Y',
      'Cookie': 'AWSALB=lTUlZyT440qTWGLE6EaW9OZrHOc28nyjCJllhV/ClI/SY46jomj1LhtYilosBiCwg8KTTm5NqSMR0PefBKxetTG+1NWzMBD9qqF0NdsgczwJy6X7wRONKg8HtGc7; AWSALBCORS=lTUlZyT440qTWGLE6EaW9OZrHOc28nyjCJllhV/ClI/SY46jomj1LhtYilosBiCwg8KTTm5NqSMR0PefBKxetTG+1NWzMBD9qqF0NdsgczwJy6X7wRONKg8HtGc7; by-kea=s%3A6TkmcPThjMKYOvPcT21ZPqOgXiowaS7O.JGue8zPhnHes2SrbrwiDZ8xW6nlskb1pWFv8PmWJdfk',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.bykea.net/api/v2/bookings/fareEstimate'));
    request.body = json.encode({
      "service_code": code,
      "customer": {
        "phone": "923111182121"
      },
      "pickup": {
        "lat": pLat,
        "lng": pLng
      },
      "dropoff": {
        "lat": dLat,
        "lng": dLng
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print(responseBody);
      fareEstimateResponse = fare.FareEstimateResponse.fromJson(jsonDecode(responseBody));
      return fareEstimateResponse;
    }
    return fareEstimateResponse;
  }

///updateDeliveryCharges
  ///Delivery charges are being updated in Confirmation page which is "Proceed" button page.
  Future<int> updateDeliveryCharges (int oid, String charges) async{
    if (oid > 0) {
      http.Response response = await http.post(
        Uri.parse("${EndPoints.apiPath}Orders/UpdateDeliveryCharges/$oid?charges=$charges"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      return response.statusCode;
    }
    else {
      return 201;
    }
  }

  ///TODO: Set notifications after implementing simple in app notifications
  ///Is used to send Notification to Riders in Internal and External pool when proceed button is pressed.
  Future<void> sendNotificationToRiders(int rid) async {
    ///Notification to Job pool
    if (rid > 0) {
      cloudStore.FirebaseFirestore.instance
          .collection("Riders")
          .where("fkRestaurantId", isEqualTo: rid)
          .get()
          .then((cloudStore.QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          ///New
          // SendMessageApi().sendMessage(receiverToken, notificationBody,
          //     notificationTitle, notificationPayloadType, notificationPayloadMessage, receiverChannelId, resId)
          SendMessageApi().sendMessage(doc['token'], "New Job in pool",
              "New Order Alert", "New Order", "", "restaurantAdmin1", EndPoints.Resturantid.toString());
          //Original
          // itemscontroller().sendPushMessage(token, title, body, data);
          // itemscontroller().sendPushMessage(doc['token'], "New job in pool",
          //     "Job sent to internal pool","",);
        });
      });
    }
    ///Notification to External pool
    // cloudStore.FirebaseFirestore.instance
    //     .collection("Riders")
    //     .where("fkRestaurantId", isEqualTo: rid)
    //     .get()
    //     .then((cloudStore.QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((doc) {
    //     ///New
    //    // SendMessageApi().sendMessage(receiverToken, notificationBody, notificationTitle,
    //    //     notificationPayloadType, notificationPayloadMessage, receiverChannelId)
    //     SendMessageApi().sendMessage(doc['token'], "New job in pool",
    //         "New Order Alert", "New Order", "", "restaurantAdmin1", "");
    //     //Original
    //     // itemscontroller().sendPushMessage(token, title, body, data)
    //     // itemscontroller().sendPushMessage(doc['token'], "New job in pool",
    //     //     "Job sent to external pool","",);
    //   });
    // });
  }
}