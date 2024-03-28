import 'dart:convert';
import 'package:http/http.dart';
import '../GlobleVariables/Globle.dart';


///New Correct
///
///TODO: Here we are making API to send to Firebase.
class SendMessageApi {
  Future<void> sendMessage(
      String receiverToken,
      String notificationBody,
      String notificationTitle,
      String notificationPayloadType,
      String notificationPayloadMessage,
      String receiverChannelId,
      String resId) async {
    print("Sending notification..........");

    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

    ///TODO: we need to set Header as below and paste Authorization key from Firebase.
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': Globle.NotificationKey,
    };

    ///TODO: This is the body data which will be converted to JSON and then stored in a variable and assigned to below response.

    Map<String, dynamic> body = {
      "to": receiverToken,
      "data": {
        "type": notificationPayloadType,
        "messageId": notificationPayloadMessage,
        "RestaurantId" : resId,
      },
      "notification": {
        "body": notificationBody,
        "title": notificationTitle,
        "android_channel_id": receiverChannelId,
        "sound": true,
        "content_available":true,// if you want to play custom sound on ios background you need to add this two attribute
        "mutable_content":true,// if you want to play custom sound on ios background you need to add this two attribute
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    ///TODO: Printing all information which is in body.
    print("operator$body");

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    ///Post API
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully......");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }
}




///Original Backup from itemscontroller.dart
//import 'dart:convert';
// import 'package:http/http.dart';
// import '../GlobleVariables/Globle.dart';
//
//
// ///New Correct
// ///
// ///TODO: Here we are making API to send to Firebase.
// class SendMessageApi {
//   Future<void> sendMessage(
//       String receiverToken,
//       String notificationBody,
//       String notificationTitle,
//       String notificationPayloadType,
//       String notificationPayloadMessage,
//       String receiverChannelId,
//       String resId) async {
//     print("Sending notification..........");
//
//     final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
//
//     ///TODO: we need to set Header as below and paste Authorization key from Firebase.
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': Globle.NotificationKey,
//     };
//
//     ///TODO: This is the body data which will be converted to JSON and then stored in a variable and assigned to below response.
//
//     Map<String, dynamic> body = {
//       "to": receiverToken,
//       "data": {
//         "type": notificationPayloadType,
//         "messageId": notificationPayloadMessage,
//         "RestaurantId" : resId,
//       },
//       "notification": {
//         "body": notificationBody,
//         "title": notificationTitle,
//         "android_channel_id": receiverChannelId,
//         "sound": true,
//         "content_available":true,// if you want to play custom sound on ios background you need to add this two attribute
//         "mutable_content":true,// if you want to play custom sound on ios background you need to add this two attribute
//         "click_action": "FLUTTER_NOTIFICATION_CLICK",
//         "image":
//         "https://imgd.aeplcdn.com/370x208/n/cw/ec/106257/venue-exterior-right-front-three-quarter-2.jpeg?isig=0&q=75"
//       },
//     };
//
//     ///TODO: Printing all information which is in body.
//     print("operator$body");
//
//     String jsonBody = json.encode(body);
//     final encoding = Encoding.getByName('utf-8');
//
//     ///Post API
//     Response response = await post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//
//     if (response.statusCode == 200) {
//       print("Notification sent successfully......");
//     } else {
//       print("Failed to send notification. Status code: ${response.statusCode}");
//     }
//   }
// }