import 'dart:async';
import 'dart:convert';
import 'package:yoracustomer/bottomdetail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/HomePage.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:yoracustomer/widgets/LoaderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoracustomer/widgets/LoaderDialog1.dart';
import 'package:yoracustomer/widgets/LoadingWidget.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudStore;
import '../LinkFiles/CustomColors.dart';

import 'Controller/BankAccountsController.dart';
import 'Controller/itemscontroller.dart';
import 'Model/Banner.dart';
import 'Model/Customer.dart';
import 'Model/Restaurant.dart';
import 'LinkFiles/EndPoints.dart';

class Formatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length <= 5) {
      return oldValue;
    }
    return newValue;
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final TextEditingController pinController;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController(text: 'Hello');
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: pinController,
      length: 10,
      toolbarEnabled: false,
      inputFormatters: [Formatter()],
    );
  }
}


class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key,required this.res, required this.sendOtp, required this.pid }) : super(key: key);
  final String res;
  final String sendOtp;
  final int pid;
  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  // TextEditingController otp = TextEditingController();
  TextEditingController VerifyOtp = TextEditingController();
  var decodedMap = 0;
  List<BannerModelS>? bannerList = [];
  bool isLoaded = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  Timer? _timer1;
  Timer? _timer2;
  int _timerSeconds = 33;
  bool pageLoaded =  false;
  bool viewOtpCode =  false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPage();
    showOtp();

  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/BG2.jpg'),
                fit: BoxFit.cover,
              )
          ),
          child: Visibility(
            visible: pageLoaded,
            replacement: const Center(
              child: LoadingWidget(msg: "",)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  Globle.LogoImg,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),

                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        // Specify direction if desired
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          length: 6,
                          controller: pinController,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          validator: (value) {
                            VerifyOtp.text = value!;
                            return value == widget.res ? null : 'Pin is incorrect';
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: CustomColors().mainThemeColor,
                    child: TextButton(
                        onPressed: () async {
                          focusNode.unfocus();
                          formKey.currentState!.validate();
                          await itemscontroller().getMenu();
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return LoaderDialog1();
                              });

                          print("ddddd"+widget.res);
                          print("rrrrrrrrr"+VerifyOtp.text);
                          if (widget.res == VerifyOtp.text) {
                            Customer cus = await itemscontroller()
                                .getCustomer(Globle.countryCode + widget.sendOtp);
                            if (cus.customerId == 0 || cus.fkRestaurantId != EndPoints.Resturantid) {
                              int sc = await signUpApi();
                              if(sc == 200)
                                {
                                  Customer cus = await itemscontroller()
                                      .getCustomer(Globle.countryCode + widget.sendOtp);
                                  if (cus.customerId > 0) {
                                    Globle.customerid = cus.customerId;
                                    Globle.customerName = cus.name;
                                    Globle.customerNumber = cus.contact;
                                    getOrderId();
                                    getBanners();
                                    SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                    String? user = json.encode(cus.toJson());
                                    preferences.setString("user", user);
                                    print(user);

                                    Restaurant restaurant =
                                    cus.restaurant as Restaurant;
                                    user = json.encode(restaurant.toJson());
                                    preferences.setString("restaurant", user);
                                    String msg = "Verified successfully";
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return LoaderDialog(msg);
                                        });
                                    getToken();
                                    initInfo();
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    Navigator.pop(context);

                                    if(widget.pid <= 0)
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Homepage()));
                                      }
                                    else
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => bottomdetail(itemId: widget.pid)));
                                      }
                                  }
                                }
                             else
                               {
                                 Navigator.pop(context);
                                 Globle().Errormsg(context, "Sorry but we are not availabe at the moment");
                               }
                            }
                            else if (cus.customerId > 0) {
                              Globle.customerid = cus.customerId;
                              Globle.customerName = cus.name;
                              Globle.customerNumber = cus.contact;
                              getOrderId();
                              getBanners();
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? user = json.encode(cus.toJson());
                              print(user);
                              preferences.setString("user", user);

                              Restaurant restaurant = cus.restaurant as Restaurant;
                              user = json.encode(restaurant.toJson());
                              preferences.setString("restaurant", user);
                              String msg = "Verified successfully";
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return LoaderDialog(msg);
                                  });
                              getToken();
                              initInfo();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.pop(context);
                              if(widget.pid <= 0)
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));
                              }
                              else
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bottomdetail(itemId: widget.pid)));
                              }
                            }
                            else {
                              Globle().Errormsg(context, "Error");
                            }
                          }
                          else {
                            Navigator.pop(context);
                            String msg = "OTP is not correct, please try again";
                            Globle().Errormsg(context, msg);
                          }
                        },
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: viewOtpCode,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "You can use ",
                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                ),
                                TextSpan(
                                  text: widget.res,
                                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                const TextSpan(
                                  text: " as OTP code if you did not receive any OTP on your number.",
                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ),
                ),
                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: CustomColors().mainThemeColor,
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Text(
                        '$_timerSeconds',
                        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: CustomColors().mainThemeTxtColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> signUpApi() async {

    Customer c = Customer(dateAdded: DateTime.now(),restaurant: Restaurant(dateAdded: DateTime.now(), from: DateTime.now(), to: DateTime.now()));
    c.deletedDate = DateTime.now();
    c.fkRestaurantId = EndPoints.Resturantid;
    c.contact = Globle.countryCode + widget.sendOtp;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('${EndPoints.apiPath}Customers/Create'));
    request.body = json.encode(c.toJson());
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response.statusCode;
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
    //setState(() {});
  }
  void loadPage() {

    _timer = Timer(const Duration(seconds: 3 ), () async {
      setState(() {
        pageLoaded = true;
      });
    });
    setState(() {

    });
  }
  void showOtp() {
    _timer1 = Timer(const Duration(seconds: 23 ), () async {
      setState(() {
        viewOtpCode = true;
      });
    });
    setState(() {
    });
    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer2?.cancel();
        }
      });
    });
  }
  getOrderId() async {
    int id = await itemscontroller().GetOrderId(context);
    if(id == 1)
    {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId)));
    }
  }

}
