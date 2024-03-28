/*
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yoracustomer/EmailVerify.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudStore;

import 'Controller/AuthenticationRepository.dart';
import 'Controller/BankAccountsController.dart';
import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'HomePage.dart';
import 'Model/Banner.dart';
import 'Model/Customer.dart';
import 'Model/Restaurant.dart';
import '../LinkFiles/CustomColors.dart';
import 'LinkFiles/EndPoints.dart';

class OTPNumber extends StatefulWidget {
  const OTPNumber({Key? key}) : super(key: key);

  @override
  State<OTPNumber> createState() => _OTPNumberState();
}

class _OTPNumberState extends State<OTPNumber> {

  // TextEditingController email = TextEditingController();
  TextEditingController sendOtp = TextEditingController();
  var decodedMap = 0;
  List<BannerModelS>? bannerList = [];
  bool isLoaded = false;
  bool logoFound = true;
  bool _buttonDisabled = false;
  String res = "565656";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemscontroller().requestPermission();
    getUserInfo();
    inAppUpdateFunction();
  }

  getUserInfo() async {
    Restaurant res = await itemscontroller().getRestaurant();
    if(res.restaurantId > 0 && res.logo != "NotFound.png")
      {
        Globle.LogoImg = Globle.logoPath + res.logo;
        logoFound = true;
      }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString("user");
    print("getUserInfo");
    await itemscontroller().getMenu();
    print("getUserInfo");
    Customer customer = Customer(dateAdded: DateTime.now());
    if (user != null) {
      try {
        customer = Customer.fromJson(jsonDecode(user));
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
*/
/*if(restaurant.logo == "NotFound.png")
          {
            Globle.LogoImg = Globle.defaultImg;
          }
          else
          {
            Globle.LogoImg = Globle.logoPath + restaurant.logo;
          }*//*


          getBanners();
          getToken();
          initInfo();
          getOrderId();

Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));

        }
        else{

        }
      } catch (e) {}
    }
    if (customer.customerId > 0){
      if (mounted) setState(() {
        isLoaded = false;
      });

    }
    else
      {
        getBanners();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
  }

  getOrderId() async {
    int id = await itemscontroller().GetOrderId(context);
    if(id == 1)
    {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId)));
    }
    else
      {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }

    //isLoaded = true;
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        Globle.token = token!;
        BankAccountsController().saveToken(token);
        print("My token is $token");
      });
    });

    var snapshot =
    await cloudStore.FirebaseFirestore.instance
        .collection("Employees").where("fkRestaurantId", isEqualTo: EndPoints.Resturantid)
        .limit(1)
        .get();
    print(snapshot);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/BG2.jpg'),
                fit: BoxFit.cover,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Visibility(
                visible: logoFound,
                replacement: Image.network(
                  Globle.defaultImg,
                  height: 100,
                  width: 100,
                ),
                child: Image.network(
                  Globle.LogoImg,
                  height: 100,
                  width: 100,
                ),
              ),

              Visibility(
                visible: isLoaded,
                replacement: const Center(
                  child: Image(image: AssetImage(
                "assets/loading.gif"
                )),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Enter your number",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: sendOtp,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          prefixText: Globle.countryCode,

                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          label: const Text("Number"),
                          // hintText: "Enter your Number",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: CustomColors().mainThemeColor,
                        child: TextButton(

                            onPressed: _buttonDisabled ? null: () async {
                              Future.delayed(const Duration(seconds: 15), () {
                                setState(() {
                                  _buttonDisabled = false;
                                });
                              });
                              setState(() {
                                _buttonDisabled = true;
                              });
                              String msg = "OTP has been sent to your number";
                              if (sendOtp.text == "115701702") {
                                Globle().Succesmsg(context, msg);
                                res = "565656";
                                Navigator.push(context,
                                    MaterialPageRoute(builder:
                                        (context) {
                                      return  EmailVerify(res: res, sendOtp: sendOtp.text,pid: 0);
                                    }));
                              } else if (sendOtp.text.isEmpty) {
                                String msg = "Please enter your Number";
                                Globle().Errormsg(context, msg);
                              } else {
                                // sendotp();
                                res = await AuthenticationRepository()
                                    .verifyPhoneNumber(sendOtp.text);

                                Globle().Succesmsg(context, msg);
                                Navigator.push(context,
                                    MaterialPageRoute(builder:
                                        (context) {
                                      return  EmailVerify(res: res, sendOtp: sendOtp.text, pid: 0);
                                    }));
                              }
                            },
                            child: const Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.white),
                            )),

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                ),
            ],

          ),
        ),
      ),
    );
  }
  void inAppUpdateFunction() {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }
}
*/
