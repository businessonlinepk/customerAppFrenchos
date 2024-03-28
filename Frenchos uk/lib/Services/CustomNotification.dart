
///Original Notification Receiver which is not being used anywhere.
// import 'dart:math';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class CustomNotification {
//   static final _notification = FlutterLocalNotificationsPlugin();
//
//   static Future init({bool scheduled = false}) async {
//     var initAndroidSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var ios = const DarwinInitializationSettings();
//     final setting = InitializationSettings(android: initAndroidSetting, iOS: ios);
//     await _notification.initialize(setting, onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse) async {
//       /*if (id!.isNotEmpty) {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => bottomdetail("","","",1,des: '',)),
//         );
//       }*/
//     },onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
//     }
//     );
//     await _notification.initialize(setting);
//   }
//
//   static Future showNotification({
//     var id = 0,
//     var title,
//     var body,
//     var payload,
//     var sound,
//     var deviceToken, // Added deviceToken parameter
//   }) async =>
//       _notification.show(id, title, body, await notificationDetails(sound), payload: deviceToken);
//
//   static Future<NotificationDetails> notificationDetails(String sound) async {
//     String soundFilePath = ''; // Initialize an empty sound file path
//
//     // Assign the appropriate sound file path based on the given sound parameter
//     if (sound == 'sound1') {
//       soundFilePath = 'loud2';
//       return NotificationDetails(
//         android: AndroidNotificationDetails(
//           "restaurantAdmin",
//           "channel",
//           importance: Importance.max,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound(soundFilePath),
//         ),
//       );
//     }
//     else if (sound == 'sound2') {
//       soundFilePath = 'loud';
//       return NotificationDetails(
//         android: AndroidNotificationDetails(
//           "restaurantAdmin1",
//           "channel1",
//           importance: Importance.max,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound(soundFilePath),
//         ),
//       );
//     }
//     else {
//       soundFilePath = 'loud1';
//       return NotificationDetails(
//         android: AndroidNotificationDetails(
//           "restaurantAdmin2",
//           "channel2",
//           importance: Importance.max,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound(soundFilePath),
//         ),
//       );
//     }
//
//   }
//
//   static void display(RemoteMessage message) async {
//     try {
//       Random random = Random();
//       int id = random.nextInt(10000);
//       const NotificationDetails notificationDetails =
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "restaurantAdmin",
//           "channel",
//           importance: Importance.max,
//           priority: Priority.high,
//           //sound: RawResourceAndroidNotificationSound("loud"),
//         ),
//       );
//       await _notification.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['_id'],
//       );
//     } on Exception catch (e) {
//       print('Error>>>$e');
//     }
//   }
//
// }