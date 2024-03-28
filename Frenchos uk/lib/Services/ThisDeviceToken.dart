
import 'package:firebase_messaging/firebase_messaging.dart';
///myToken is for Notification Sender (SendingMessageApi)
late String myToken;

Future thisDeviceToken() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    myToken = (await fcm.getToken())!;
    print("My Token => $myToken");
    return myToken;
  }