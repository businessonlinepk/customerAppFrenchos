import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:yoracustomer/Services/App_Updater.dart';
import 'Controller/itemscontroller.dart';
import 'Model/Banner.dart';
import 'Model/Restaurant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controller/BankAccountsController.dart';
import 'GlobleVariables/Globle.dart';
import 'Model/Customer.dart';
import 'dart:io' show Platform;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  List<BannerModelS>? bannerList = [];
  bool loadNow = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    ///FCM Notifications Permission, Original, Commented out
    // itemscontroller().requestPermission();
    getUserInfo();
    // inAppUpdateFunction();
    Future.delayed(const Duration(seconds:5), () {
      whereToGo();
      ///For Forced update
      // inAppUpdateFunction(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: loadNow,
      replacement: Container(
        decoration:const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/SplashScreen.png"),
            fit: BoxFit.cover,
          ),
        ),

      ),
      child: Container(
        decoration:const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/SplashScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Image(image: AssetImage(
              "assets/loading.gif"
          ),
          ),
        ),
      ),
    );
  }

  Future<void> whereToGo() async {
    setState(() {
      loadNow = true;
    });
  }

  ///This "inAppUpdatefunction" is using "in-app-update" Package, which does not have min-version property
  ///so we are using "Upgrader" package which does have min-version for Forced-update.
  ///New file "App_Upgrader.dart" is added in Services Directory for upgrader functionality.
  // void inAppUpdateFunction() {
  //   InAppUpdate.checkForUpdate().then((updateInfo) {
  //     if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
  //       if (updateInfo.immediateUpdateAllowed) {
  //         // Perform immediate update
  //         InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
  //           if (appUpdateResult == AppUpdateResult.success) {
  //             //App Update successful
  //           }
  //         });
  //       } else if (updateInfo.flexibleUpdateAllowed) {
  //         //Perform flexible update
  //         InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
  //           if (appUpdateResult == AppUpdateResult.success) {
  //             //App Update successful
  //             InAppUpdate.completeFlexibleUpdate();
  //           }
  //         });
  //       }
  //     }
  //   });
  // }

  getUserInfo() async {
    Restaurant res = await itemscontroller().getRestaurant();
    getBanners();
    if(res.restaurantId > 0 )
    {
      if(res.logo != "NotFound.png")
      {
        Globle.LogoImg = Globle.logoPath + res.logo;
      }
      Globle.deliveryTime = res.waitingTime;
      Globle.homeMinimumOrder = res.minimumOrder;
      //logoFound = true;
    }

    await itemscontroller().getMenu();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString("user");
    Customer customer = Customer(dateAdded: DateTime.now());
    if (user != null) {
      print("if (user != null)");
      try {
        customer = Customer.fromJson(jsonDecode(user));
        print("user");
        if (customer.customerId > 0) {
          Globle.customerid = customer.customerId;
          Globle.customerName = customer.name;
          Globle.customerNumber = customer.contact;
          if(res.restaurantId > 0)
          {
            customer.restaurant = res;
            String? cus = json.encode(customer.toJson());
            preferences.setString("user", cus);
          }
          getToken();
          initInfo();
          getOrderId();
        }
        else{
          getUserInfo();
        }
      } catch (e) {}
    }
    if (customer.customerId > 0){
      if (mounted) {
        setState(() {
          isLoaded = false;
        });
      }
    }
    else
    {
      getBanners();
      getUniqueIdentifier();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (Route<dynamic> route) => false,
      );
    }
  }

  getUniqueIdentifier() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? uniqueId = '';

    try {

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        uniqueId = androidInfo.id; // Use Android ID for Android devices
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        uniqueId = iosInfo.identifierForVendor; // Use Identifier for Advertising for iOS devices
      }
    } catch (e) {
      print('Error retrieving device information: $e');
    }
    Globle.uniqueId = uniqueId!;
    ///Saving token to server1
    if(uniqueId != '')
    {
      ///generating this device token
      await FirebaseMessaging.instance.getToken().then((token) async {
        setState(() {
          Globle.token = token!;
        });
        ///Saving token function to server api, but it has get method.
        int a = await itemscontroller().saveTokenToServer1(token!);
        print("saveTokenToServer1  "+a.toString()+ ":  uniqueId" + uniqueId!);
      });
    }
  }

  getOrderId() async {
    int id = await itemscontroller().GetOrderId(context);
    if(id == 1)
    {
      print("Going to Order Status Screen, Payment.dart");
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId)));
    }
    else
    {
      /*Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));*/
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (Route<dynamic> route) => false,
      );
    }

    //isLoaded = true;
  }
///Saving customer token to firebase
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        Globle.token = token!;
        BankAccountsController().saveToken(token);
        print("My token is $token");
      });
    });
  }

  Future<void> initInfo() async {
    var androidInitailize =
    const AndroidInitializationSettings('(@mipmap/ic_launcher)');
    var iosInitailize = const DarwinInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: androidInitailize, iOS: iosInitailize);
    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        "restaurantAdmin",
        "channelName",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
      );
      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const DarwinNotificationDetails());
      flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

  Future<void> getBanners() async {
    Globle.bannerDataList = await itemscontroller().fetchBanners();
    if(mounted) {
      setState(() {});
    }
  }
}
