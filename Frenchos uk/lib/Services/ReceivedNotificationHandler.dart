import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';


///TODO: Processing Received Notifications------------------------------------->

class NotificationProcessor {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //Instance of Flutter Notification Plugin.
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    //For both Android and IOS
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Notification Permission------------------>");
      //For IOS
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional Notification Permission------>");
    } else {
      //For opening App Notification Settings if Notification Permission denied.
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print("User Denied Notification Permission------------------->");
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
          // Extract data from the payload
          String type = message.data['type'] ?? '';
          String payloadMessage = message.data['message'] ?? '';

          // Handle the received payload
          handlePayload(context, type, payloadMessage);
        });
  }

// Handle the message when the app is in the foreground
  void onMessage(BuildContext context, GlobalKey<NavigatorState> navigatorKey) {
    ///TODO: onMessage listener
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotifications(context, message);
      if(Platform.isIOS){
        foregroundMessage();
      }
      if (message.notification!.title!.startsWith("New Order")) {
        NotificationReceiver.NewOrder(message);
      } else if (message.notification!.title!.startsWith("New Message")) {
        NotificationReceiver.NewMessage(message);
      } else if (message.notification!.title!.startsWith("Order Cancelled")) {
        NotificationReceiver.Other(message);
      }else{
        print("Notification Received but title is is not matching, title => ${message.notification!.title!}");
      }
      ///Seeing data received from notification for payload
      print("Notification Data Received------------------------------------->");
      print('Got a message whilst in the foreground! OnMessage Called');
      print('Message data: ${message.data}');

      // Extract data from the payload
      String type = message.data['type'] ?? '';
      String payloadMessage = message.data['message'] ?? '';

      // // Handle the received payload
      // handlePayload(context, type, payloadMessage);

    });
  }

// Handle the message when the app is opened by tapping on the notification
  Future<void> onMessageOpenedApp(BuildContext context, GlobalKey<NavigatorState> navigatorKey) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      void handleNotification(RemoteMessage message) {
        if (message.notification!.title!.startsWith("New Order")) {
          NotificationReceiver.NewOrder(message);
        } else if (message.notification!.title!.startsWith("New Message")) {
          NotificationReceiver.NewMessage(message);
        } else if (message.notification!.title!.startsWith("Order Cancelled")) {
          NotificationReceiver.Other(message);
        } else {
          print("Notification Received but title is is not matching, title => ${message.notification!.title!}");
        }

        // Extract data from the payload
        String type = message.data['type'] ?? '';
        String payloadMessage = message.data['message'] ?? '';

        // Handle the received payload
        handlePayload(context, type, payloadMessage);

      }
      handleNotification(message);
      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        // Extract data from the payload
        String type = message.data['type'] ?? '';
        String payloadMessage = message.data['message'] ?? '';

        // Handle the received payload
        handlePayload(context ,type, payloadMessage);
      }
      handleNotification(initialMessage!);
    });
  }

  // Future<String> getDeviceToken() async {
  //   String? token = await messaging.getToken();
  //   return token!;
  // }

  void handlePayload( BuildContext context, String type, String message, ) {
    print('Handle message hit with =>');
    print("Message =>$message");
    print("Type =>$type");

    ///TODO:  Please Check for Navigation  with notification payload by uncommenting the below code and changing the Page route.
    try{
      // if(type == "New Order") {
      //   navigatorKey.currentState?.push(
      //       MaterialPageRoute(builder: (context) => OrdersView()));
      // }
      // else if (type == "msg") {
      //   navigatorKey.currentState?.push(
      //       MaterialPageRoute(builder: (context) =>  OrderDetail(oid: message.data["id"],)
      //       ));
      // }
      // else {
      //   print("But type is not matching, type received is => $type");
      // }

    }catch(e) { print("Error while navigating with payload => $e");}
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

}


///TODO: Showing Received Notifications---------------------------------------->
class NotificationReceiver {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init({bool scheduled = false}) async {
    var initAndroidSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const DarwinInitializationSettings();
    final setting = InitializationSettings(android: initAndroidSetting, iOS: ios);
    await _notification.initialize(setting);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  }


  static void NewOrder(RemoteMessage message) async {
    print("NewOrder Notification is hit");
    print("Received title: ${message.notification!.title!}");
    print("Received body: ${message.notification!.body!.toString()}");
    try {
      Random random = Random();
      int id = random.nextInt(10000);
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        "restaurantAdmin1",
        "high_importance_channel1",
        importance: Importance.max,
      );

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: "This channel is used for important notifications",
        importance: channel.importance,
        priority: Priority.high,
        ticker: "ticker",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("order"),
      );

      DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        sound: "order.caf"
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );
      // NotificationDetails notificationDetails =
      // const NotificationDetails(
      //   android: AndroidNotificationDetails(
      //     playSound: true,
      //     "restaurantAdmin1",
      //     "high_importance_channel1",
      //     importance: Importance.max,
      //     priority: Priority.high,
      //     sound: RawResourceAndroidNotificationSound("order"),
      //   ),
      // );
      await _notification.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['type'],
      );
    } on Exception catch (e) {
      print('Error showing NewOrder Notification>>>$e');
    }
  }
  static void NewMessage(RemoteMessage message) async {
    print("NewMessage Notification is hit");
    print("Received title: ${message.notification!.title!}");
    print("Received body: ${message.notification!.body!.toString()}");
    try {
      Random random = Random();
      int id = random.nextInt(10000);
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        "restaurantAdmin2",
        "high_importance_channel2",
        importance: Importance.max,
      );

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: "This channel is used for important notifications",
        importance: channel.importance,
        priority: Priority.high,
        ticker: "ticker",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("message"),
      );

      DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        sound: "message.caf"
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );
      // NotificationDetails notificationDetails =
      // const NotificationDetails(
      //   android: AndroidNotificationDetails(
      //     playSound: true,
      //     "restaurantAdmin1",
      //     "high_importance_channel1",
      //     importance: Importance.max,
      //     priority: Priority.high,
      //     sound: RawResourceAndroidNotificationSound("order"),
      //   ),
      // );
      await _notification.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['type'],
      );
    } on Exception catch (e) {
      print('Error showing NewMessage Notification>>>$e');
    }
  }

  static void Other(RemoteMessage message) async {
    print("Other Notification is hit");
    print("Received title: ${message.notification!.title!}");
    print("Received body: ${message.notification!.body!.toString()}");
    try {
      Random random = Random();
      int id = random.nextInt(10000);
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        "restaurantAdmin3",
        "high_importance_channel3",
        importance: Importance.max,
      );

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: "This channel is used for important notifications",
        importance: channel.importance,
        priority: Priority.high,
        ticker: "ticker",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("message"),
      );

      DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        sound: "message.caf"
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      // const NotificationDetails notificationDetails =
      // NotificationDetails(
      //   android: AndroidNotificationDetails(
      //     playSound: true,
      //     "restaurantAdmin3",
      //     "high_importance_channel3",
      //     importance: Importance.max,
      //     priority: Priority.high,
      //     sound: RawResourceAndroidNotificationSound("message"),
      //   ),
      // );
      await _notification.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['type'],
      );
    } on Exception catch (e) {
      print('Error showing Notification>>>$e');
    }
  }
}

