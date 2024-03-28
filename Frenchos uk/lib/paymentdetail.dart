import 'dart:async';
import 'dart:convert';

import 'package:animated_icon/animated_icon.dart';
import 'package:yoracustomer/ChatView.dart';
import 'package:yoracustomer/Controller/AuthenticationRepository.dart';
import 'package:yoracustomer/Controller/ChatsController.dart';
import 'package:yoracustomer/Controller/OrderCancelLogController.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/HomePage.dart';
import 'package:yoracustomer/Model/Customer.dart';
import 'package:yoracustomer/Model/OrderCancelLog.dart';
import 'package:yoracustomer/Model/OrderCancelOption.dart';
import 'package:yoracustomer/Model/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Controller/itemscontroller.dart';
import 'Model/BykeaResponse.dart';
import 'Model/OrderLog.dart';
import 'Model/Restaurant.dart';
import 'Model/Rider.dart';
import '../LinkFiles/CustomColors.dart';

///TODO: This is Order Status Page, Payment Details page which comes after "Proceed button/Confirmation.dart"
///Single Screen

class paymentdetail extends StatefulWidget {
  const paymentdetail(this.intruction, {Key? key, required this.oid})
      : super(key: key);

  final int oid;
  final String intruction;

  @override
  State<paymentdetail> createState() => _paymentdetailState();
}

class _paymentdetailState extends State<paymentdetail> {
  Order order = Order(
      dateAdded: DateTime.now(),
      dispatchTime: DateTime.now(),
      deliveryTime: DateTime.now(),
      preparationTime: DateTime.now(),
      customer: Customer(dateAdded: DateTime.now()));
  Rider rider = Rider(dateAdded: DateTime.now(),dob:  DateTime.now());

  //call variables
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';
  //
  int rMessages = 0;
  int eMessages = 0;
  int xMessages = 0;
  //
  double total = 0;
  int nextTime = 35;
  bool isLoaded = false;
  Timer? _timerr;
  Timer? _setTime;
  bool succes = false;
  bool timerStart = false;
  bool cancel = false;
  int selectedRadioId = 0;
  String msg = "";
  String bykeaTracking = "";
  OrderCancelLog newLog = OrderCancelLog(dateAdded: DateTime.now());
  List<OrderCancelOption>? cancelLogs;
  Restaurant res = Restaurant(dateAdded: DateTime.now(), from: DateTime.now(), to: DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
    getOrder();
    getCancelLogList();
    //getRestaurant();
    startTimer();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  getRestaurant()
  async {
    if(order.orderId > 0)
    {
      if(Globle.waitingTime == 0)
      {
        final prefs = await SharedPreferences.getInstance();
        var resFromJson = prefs.getString("restaurant");
        res = Restaurant.fromJson(jsonDecode(resFromJson!));
        if(res.restaurantId > 0) {
          setState(() {
            DateTime currentTime = DateTime.now();
            if(order.orderType == false && order.orderStatus != 'w') {
              var time = order.preparationTime.subtract(Duration(hours: currentTime.hour,minutes: currentTime.minute));
              if(time.minute > 4)
              {
                Globle.waitingTime = time.minute;
                nextTime = Globle.waitingTime + 5;
              }
              else {
                Globle.waitingTime = 5;
                nextTime = Globle.waitingTime + 5;
              }
            }
            else {
              var preparationTime =
              order.dateAdded.add(Duration(minutes: res.waitingTime));
              var time = preparationTime.subtract(Duration(
                  hours: currentTime.hour, minutes: currentTime.minute));
              if (time.minute > 4) {
                Globle.waitingTime = time.minute;
                nextTime = Globle.waitingTime + 5;
              } else {
                Globle.waitingTime = 5;
                nextTime = Globle.waitingTime + 5;
              }
            }
          });
        }
        else
        {
          setState(() {
            Globle.waitingTime = res.waitingTime;
            nextTime = Globle.waitingTime + 5;
          });
        }
      }
    }
  }

  getMessages() async {
     eMessages = await ChatsController().getUnreadMessages(order.orderId, 'e');
     rMessages = await ChatsController().getUnreadMessages(order.orderId, 'r');
     xMessages = await ChatsController().getUnreadMessages(order.orderId, 'x');
     setState(() {

     });
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void dispose(){
    super.dispose();
    _timerr!.cancel();
    _setTime!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //getOrder();
    //setWaitingTime();
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press event here.
          // Return true if you want to allow the back button press,
          // or false if you want to block the back button press.
          // For example, to block the back button press if a dialog is open:
          if (!Globle.OrderGenerated && Globle.OrderId == 0) {
            return true;
          } else {
            //Globle().Errormsg(context, "Sorry but you cannot navigate back from this page until your order is completed or cancelled");
            Fluttertoast.showToast(
              msg: "Sorry but you cannot navigate back from this page until your order is completed or cancelled",
              toastLength: Toast.LENGTH_LONG,
              fontSize: 15,
              backgroundColor: CustomColors().secondThemeColor,
              textColor: CustomColors().secondThemeTxtColor,
            );return false;
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Order status",
                  style: TextStyle(color: CustomColors().mainThemeTxtColor),
                ),

              ),
              backgroundColor: CustomColors().mainThemeColor,

            ),
            body: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  buildDetail(),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: succes == true
                                ? Card(
                              elevation: 8,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: CustomColors().mainThemeColor,
                                child: TextButton(
                                  onPressed: () async {
                                    //
                                    Globle.OrderGenerated = false;
                                    Globle.OrderId = 0;
                                    Customer.itemsCount = 0;
                                    Globle.waitingTime = 0;

                                    Navigator.of(context).popUntil(
                                            (route) => route.isFirst);
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Homepage()));
                                  },
                                  child: const Text(
                                    "Go to Homepage",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                                : cancel == true
                                ? Card(
                              elevation: 8,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: CustomColors().mainThemeColor,
                                child: TextButton(
                                  onPressed: () async {
                                    //
                                    Globle.OrderGenerated = false;
                                    Globle.OrderId = 0;
                                    Globle.waitingTime = 0;
                                    Navigator.of(context).popUntil(
                                            (route) => route.isFirst);
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Homepage()));
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Go to Homepage",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                                : null,
                          ),
                        ],
                      ))
                ]),
          ),
        ));
  }

  Widget buildDetail() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: Image(image: AssetImage(
              "assets/loading.gif"
          )),
        ),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                if (order.orderStatus == 'd') ...[
                  const Image(
                    image: AssetImage("assets/complete.png"), //height: 100,
                    width: 150,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Happy meal",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ]
                else if(order.orderStatus == 'c')...[
                  const Image(image: AssetImage(
                      "assets/cancel.png"
                  ),//height: 100,
                    width: 150,),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Order cancelled",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ]
                else ...[
                    const Image(image: AssetImage(
                        "assets/cooking.gif"
                    ),//height: 100,
                      width: 150,),
                    const SizedBox(
                      height: 10,
                    ),
                    if(order.orderType)...[
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Expected delivery time" ,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        " ${Globle.waitingTime} to $nextTime minutes",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),

                    ]
                    else...[
                      if(order.orderStatus == 'r')...[
                        const Text(
                          "Please collect your food from restaurant",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                        ),
                      ]
                      else...[
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Order will be ready in" ,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          " ${Globle.waitingTime} to $nextTime minutes",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ]
                    ],
                  ],
                const Divider(
                  color: Colors.black54,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(order.orderStatus == 'd')...[
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: CustomColors().mainThemeColor,
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: CustomColors().mainThemeColor,
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: CustomColors().mainThemeColor,
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: CustomColors().mainThemeColor,
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: CustomColors().mainThemeColor,
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                    ]
                    else if(order.orderStatus == 'c')...[
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: const Color.fromRGBO(0,0,0, 1),
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: Color.fromRGBO(
                            /*Random.secure().nextInt(255),
                        Random.secure().nextInt(255),
                        Random.secure().nextInt(255),*/
                              0,0,0,
                              1),
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: const Color.fromRGBO(0,0,0, 1),
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: const Color.fromRGBO(0,0,0, 1),
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.onlyIcon,
                          height: 40,
                          width: 40,
                          color: const Color.fromRGBO(0,0,0, 1),
                          animateIcon: AnimateIcons.loading3,
                        ),
                      ),
                    ]
                    else if(order.orderStatus == 'r')...[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.onlyIcon,
                            height: 40,
                            width: 40,
                            color: CustomColors().mainThemeColor,
                            animateIcon: AnimateIcons.loading3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.onlyIcon,
                            height: 40,
                            width: 40,
                            color: CustomColors().mainThemeColor,
                            animateIcon: AnimateIcons.loading3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.onlyIcon,
                            height: 40,
                            width: 40,
                            color: CustomColors().mainThemeColor,
                            animateIcon: AnimateIcons.loading3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.onlyIcon,
                            height: 40,
                            width: 40,
                            color: CustomColors().mainThemeColor,
                            animateIcon: AnimateIcons.loading3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.continueAnimation,
                            height: 40,
                            width: 40,
                            color: CustomColors().mainThemeColor,
                            animateIcon: AnimateIcons.loading3,
                          ),
                        ),
                      ]
                      else...[
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: AnimateIcon(
                              key: UniqueKey(),
                              onTap: () {},
                              iconType: IconType.onlyIcon,
                              height: 40,
                              width: 40,
                              color: CustomColors().mainThemeColor,
                              animateIcon: AnimateIcons.loading3,
                            ),
                          ),
                          if(Globle.waitingTime < 20)...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.onlyIcon,
                                height: 40,
                                width: 40,
                                color: CustomColors().mainThemeColor,
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ]
                          else if(Globle.waitingTime >= 20)...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.continueAnimation,
                                height: 40,
                                width: 40,
                                color: CustomColors().mainThemeColor,
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ]
                          else...[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: AnimateIcon(
                                  key: UniqueKey(),
                                  onTap: () {},
                                  iconType: IconType.onlyIcon,
                                  height: 40,
                                  width: 40,
                                  color: const Color.fromRGBO(0, 0, 0, 1.0),
                                  animateIcon: AnimateIcons.loading3,
                                ),
                              ),
                            ],
//
                          if(Globle.waitingTime < 12)...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.onlyIcon,
                                height: 40,
                                width: 40,
                                color: CustomColors().mainThemeColor,
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ]
                          else if(Globle.waitingTime >= 12 && Globle.waitingTime < 20)...[Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: AnimateIcon(
                              key: UniqueKey(),
                              onTap: () {},
                              iconType: IconType.continueAnimation,
                              height: 40,
                              width: 40,
                              color: CustomColors().mainThemeColor,
                              animateIcon: AnimateIcons.loading3,
                            ),
                          ),]
                          else...[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: AnimateIcon(
                                  key: UniqueKey(),
                                  onTap: () {},
                                  iconType: IconType.onlyIcon,
                                  height: 40,
                                  width: 40,
                                  color: const Color.fromRGBO(0, 0, 0, 1.0),
                                  animateIcon: AnimateIcons.loading3,
                                ),
                              ),
                            ],
//
                          if(Globle.waitingTime < 7)...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.onlyIcon,
                                height: 40,
                                width: 40,
                                color: CustomColors().mainThemeColor,
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ]
                          else if(Globle.waitingTime >= 7 && Globle.waitingTime < 12)...[Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: AnimateIcon(
                              key: UniqueKey(),
                              onTap: () {},
                              iconType: IconType.continueAnimation,
                              height: 40,
                              width: 40,
                              color: CustomColors().mainThemeColor,
                              animateIcon: AnimateIcons.loading3,
                            ),
                          ),]
                          else...[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: AnimateIcon(
                                  key: UniqueKey(),
                                  onTap: () {},
                                  iconType: IconType.onlyIcon,
                                  height: 40,
                                  width: 40,
                                  color: const Color.fromRGBO(0, 0, 0, 1.0),
                                  animateIcon: AnimateIcons.loading3,
                                ),
                              ),
                            ],
//
                          if(Globle.waitingTime < 7)...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.continueAnimation,
                                height: 40,
                                width: 40,
                                color: CustomColors().mainThemeColor,
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ]
                          else...[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.onlyIcon,
                                height: 40,
                                width: 40,
                                color: const Color.fromRGBO(0, 0, 0, 1.0),
                                animateIcon: AnimateIcons.loading3,
                              ),
                            ),
                          ],
                        ]
                  ],
                ),

                const Divider(
                  color: Colors.black54,
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: order.orderStatus == 'w'? 120:120,
                  child: Column(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            if (rider.riderId != 0 && order.orderStatus != 'd') ...[
                              const Text("Contact Rider",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                              ElevatedButton(
                                onPressed:() => setState(() {
                                  _launched =
                                      _makePhoneCall(_phone);
                                }),
                                child: const Icon(Icons.call),
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)),
                                  );
                                },
                                child:rMessages > 0? buildBadge1('r'):buildBadge2('r'),
                              ),

                            ],
                          ],
                        ),
                      ),
                      //waiting for acceptance
                      if (order.orderStatus == 'w') ...[
                        Card(
                          elevation: 8,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            color: CustomColors().mainThemeColor,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                //"Waiting for acceptance",
                                "Order is being prepared",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                      ///Cancel order Button
                      ///Todo: Card to cancel the order which is in Order Status screen which is
                      ///in paymentdetail.dart which is displayed after proceed button is pressed.
                        if(order.orderStatus == 'x' || order.orderStatus == 'b')...[
                          ///Customer Order Cancel Card which has cancel button as well as it's confirmation box
                          Card(
                            elevation: 8,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.redAccent,
                              ///Order Cancel Button
                              child: TextButton(
                                onPressed: () {
                                  ///Cancel Order confirmation box.
                                  showDialog(context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Confirmation"),
                                      content: const Text("Are you sure you want to cancel this order?"),
                                      actions: [
                                        TextButton(onPressed: () async {
                                          Navigator.pop(context);
                                          ///updateOrderStatus required field(Order ID, Order Status)
                                          int sc = await itemscontroller().updateOrderStatus(widget.oid, "c");
                                          if(sc == 200)
                                          {
                                            setOrderCancelLog();
                                          }
                                          else
                                          {

                                            Globle().Errormsg(context, "Error, Please try again");
                                          }
                                        }, child: const Text("Yes")),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: const Text("No"))
                                      ],
                                    ),);
                                },
                                child: const Text(
                                  "Cancel order",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ]
                      //order is being prepared
                      else if (order.orderStatus == 'i' || order.orderStatus == 's') ...[
                        Card(
                          elevation: 8,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            color: CustomColors().mainThemeColor,
                            child: TextButton(
                              onPressed: () {

                              },
                              child: const Text(
                                "Order is being prepared",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ]
                      //waiting for rider to pick up order from restaurant
                      else if (order.orderStatus == 'p') ...[
                          Card(
                            elevation: 8,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              color: CustomColors().mainThemeColor,
                              child: TextButton(
                                onPressed: () {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));*/
                                },
                                child: const Text(
                                  "Order is being prepared",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ]
                        //rider is on the way
                        else if (order.orderStatus == 'o') ...[
                            Card(
                              elevation: 8,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: CustomColors().mainThemeColor,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Rider is on the way",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ]
                          //cash payment
                          else if (order.orderStatus == 'c') ...[
                              Card(
                                elevation: 8,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: CustomColors().mainThemeColor,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "We are sorry! Your order has been cancelled",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ]
                            //reached at destination point
                            else if (order.orderStatus == 'r' && order.orderType == false) ...[Card(
                                elevation: 8,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: CustomColors().mainThemeColor,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Food is Ready to collect",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )]
                              //
                              else if (order.orderStatus == 'r') ...[
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      color: CustomColors().mainThemeColor,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Arrived",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                                //
                                else if (order.orderStatus == 'd') ...[
                                    Card(
                                      elevation: 8,
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        color: CustomColors().mainThemeColor,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "The order has been delivered successfully",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                                  else if (order.orderStatus == 'i')...[
                                      if(bykeaTracking == "accepted")...[
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            color: CustomColors().mainThemeColor,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Order is being prepared",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                      else if(bykeaTracking == "arrived")...[
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            color: CustomColors().mainThemeColor,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Reached at Pickup",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                      else if(bykeaTracking == "started")...[
                                          Card(
                                            elevation: 8,
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              color: CustomColors().mainThemeColor,
                                              child: TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  "Rider On the way",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                        else if(bykeaTracking == "finished")...[
                                            Card(
                                              elevation: 8,
                                              child: Container(
                                                width: double.infinity,
                                                height: 50,
                                                color: CustomColors().mainThemeColor,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Arrived",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]
                                          else if(bykeaTracking == "feedback")...[
                                            Card(
                                                elevation: 8,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 50,
                                                  color: CustomColors().mainThemeColor,
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                      "Delivered successfully",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                            else...[
                                                Card(
                                                  elevation: 8,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50,
                                                    color: CustomColors().mainThemeColor,
                                                    child: TextButton(
                                                      onPressed: () {},
                                                      child: const Text(
                                                        "Order is being prepared",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]
                                    ],
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      if (order.orderStatus != 'd' && order.orderStatus != 'c') ...[
                        const Text("Contact Restaurant",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)),
                            );
                          },
                          child: eMessages > 0? buildBadge1('e'):buildBadge2('e'),
                        ),


                      ],
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: ( ) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"x",receiverId: 0,)),
                        );
                      },
                      //child: const Text("Need help? click here",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    child: xMessages > 0? buildBadge("x"):buildBadge0('x'),
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width:220,
                        child: Text(
                          "Order number",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Text(order.orderId.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width:220,
                        child: Text(
                          "Order type",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      if(order.orderType)...[
                        const Text("Delivery",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ]else...[
                        const Text("Collection",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ]

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width:220,
                        child: Text("Total", style: TextStyle(fontSize: 15)),
                      ),
                      Text(Globle.showPrice(total),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child:  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width:220,
                        child: Text("Subtotal", style: TextStyle(fontSize: 15)),
                      ),
                      Text(
                          Globle.showPrice(order.productsAmount),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if(order.orderType == true && order.deliveryCharges > 0)...
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///TODO: Correct Delivery fee
                        const SizedBox(
                          width:220,
                          child: Text("Delivery Fee", style: TextStyle(fontSize: 15)),
                        ),
                        Text(
                            Globle.showPrice(order.deliveryCharges),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
                if(order.tax > 0)
               ...[
                 Padding(
                   padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                   child: Row(
                     //mainAxisAlignment: MainAxisAlignment.spaceBetweehyvuhjvbhjvbyuhvyun,
                     children: [
                       const SizedBox(
                         width:220,
                         child: Text("Total Tax", style: TextStyle(fontSize: 15,)),
                       ),
                       Text(Globle.showPrice(order.tax),
                           style: const TextStyle(
                               fontSize: 18, fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
               ],
                if(order.discount > 0)
                  ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width:220,
                            child: Text("Discount", style: TextStyle(fontSize: 15,)),
                          ),
                          Text(Globle.showPrice(order.discount),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width:220,
                        child: Text("Total (incl. VAT)", style: TextStyle(fontSize: 15,)),
                      ),
                      Text(Globle.showPrice(total),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Payment Method",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          if (order.paymentType == "c") ...[
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Cash ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                          ] else ...[
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Paid online",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                          ],

                        ],

                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    _timerr = Timer.periodic(const Duration(seconds: 20), (Timer t) async {
      buildDetail();
      getOrder();
    });
  }

  Future<void> setWaitingTime() async {

    if(order.orderType) {
      if (order.orderStatus == 'r') {
        Globle.waitingTime = 0;
      }
      else if (order.orderStatus != 'c') {
        if (Globle.waitingTime >= 30) {
          Globle.waitingTime = Globle.waitingTime - 5;
        }
        else if (Globle.waitingTime >= 20 && Globle.waitingTime < 30) {
          Globle.waitingTime = Globle.waitingTime - 4;
        }
        else if (Globle.waitingTime >= 12 && Globle.waitingTime < 20) {
          Globle.waitingTime = Globle.waitingTime - 3;
        }
        else if (Globle.waitingTime >= 7 && Globle.waitingTime < 12) {
          Globle.waitingTime = Globle.waitingTime - 2;
        }
        else {
          Globle.waitingTime = 5;
        }
      }
    }
    if(order.orderStatus == 'c')
    {
      Globle.waitingTime = 0;
    }
    if(order.orderStatus == 'c')
    {
      Globle.waitingTime = 0;
    }
    nextTime = Globle.waitingTime + 5;
    setState(() {

    });


  }

  getCancelLogList()
  async {

    cancelLogs = await OrderCancelLogController().getCancelOptions();
    setState(() {

    });
  }

  Future<void> getOrder() async {
    getMessages();
    order = await itemscontroller().orderFinalDetail(widget.oid.toString());
    rider = await itemscontroller().getRiderByOrderId(order.orderId);
    if (order.orderId > 0) {
      print("ddddddddddddddddddddd"+order.orderStatus);

      if(order.orderStatus == 'i' || order.orderStatus == 'd'|| order.orderStatus == 'x' || order.orderStatus == 'w'){
        BykeaResponse bykeaResponse = await AuthenticationRepository().trackBooking("123", order.orderId);
        bykeaTracking = bykeaResponse.data.tripStatus;
        print("ssssssssssssssssssss"+order.orderStatus);
        if(bykeaTracking == "feedback")
        {
          await itemscontroller().updateOrderStatus(order.orderId, "d");
          await itemscontroller().updateBooking(order.orderId, "c");
        }
        else if(bykeaTracking == "accepted"){
          await itemscontroller().updateBooking(order.orderId, "a");
          if(order.orderStatus == 'x'){
            await itemscontroller().updateOrderStatus(order.orderId, "w");
          }
        }
      }

      newLog.fkOrderId = order.orderId;
      if(order.orderType == false && order.orderStatus == 'i' )
      {
        if(order.preparationTime.hour == DateTime.now().hour && order.preparationTime.minute == DateTime.now().minute)
        {
          Globle.waitingTime = 1;
          nextTime = Globle.waitingTime + 5;
        }
        else if(order.preparationTime.hour >= DateTime.now().hour && order.preparationTime.minute > DateTime.now().minute)
        {
          DateTime currentTime = DateTime.now();
          var time = order.preparationTime.subtract(Duration(hours: currentTime.hour,minutes: currentTime.minute));
          Globle.waitingTime = time.minute;
          nextTime = Globle.waitingTime + 5;
        }

      }
      setState(() {
        print("rashid"+order.deliveryCharges.toString());
        // TODO: isLoaded = true for removing loader widget
        isLoaded = true;
        _phone = rider.contactNo;
        total = order.tax + order.deliveryCharges + order.productsAmount - order.discount;
        if (order.orderStatus == 'd' && order.paymentHolder != 'c') {
          Globle.OrderGenerated = false;
          // succes=true;
          setState(() {});
        }
        if(order.orderStatus != "w" && timerStart == false)
        {
          _setTime = Timer.periodic(const Duration(minutes: 5), (Timer t) async {
            setWaitingTime();
          });
          timerStart = true;
        }

        if (order.orderStatus == 'd') {
          setWaitingTime();
          succes = true;
        }
        if (order.orderStatus == 'c') {
          setWaitingTime();
          cancel = true;
        }
        if (order.orderStatus == 'r') {
          setWaitingTime();
        }
      });

      if (mounted) setState(() {});
    }
    if (mounted) setState(() {});
    if(order.orderId >0 && Globle.waitingTime == 0){
      getRestaurant();
    }
  }

  setOrderCancelLog() async {
    getOrder();
    //Below Infomsg is for Showing snackbar.
    Globle().Infomsg(context, "Order cancelled successfully");
    Globle.OrderGenerated = false;
    Globle.OrderId = 0;
    Customer.itemsCount = 0;
    Globle.waitingTime = 0;
    TextEditingController msg = TextEditingController();

    // order cancel options
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            title: const Text("Please provide us a reason of this cancellation",style: TextStyle(fontSize: 17),),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  Column(
                    children: cancelLogs!.asMap().entries.map((entry) {
                      int index = entry.value.orderCancelOptionId;
                      String item = entry.value.message;
                      return RadioMenuButton(
                        //title: Text(item),
                        value: index,
                        groupValue: selectedRadioId,
                        onChanged: (val) {
                          setState(() {
                            selectedRadioId = val!;
                            index = val;
                            msg.text = entry.value.message;
                          });
                        },
                        child: Text(item),
                        //activeColor: Colors.blue,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: msg,
                    decoration: const InputDecoration(
                      hintText: "Other",
                      labelText: "Other",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homepage()));
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homepage()));

                  OrderLog o = OrderLog(dateAdded: DateTime.now());
                  o.fkOrderId = widget.oid;
                  o.message = msg.text;
                  OrderCancelLogController().addOrderLog(o);
                  Globle().Succesmsg(context, "Thank you for submitting, we will review the message");

                  //newLog.message = msg;
                  //int check = await OrderCancelLogController().addLog(newLog);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      ),
    );
    //end
  }

  buildBadge(String type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed:type == 'x'? () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"x",receiverId: 0,)));
            setState(() {});
          }:type == 'r'?() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
            setState(() {});
          }:() {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)));
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColors().mainThemeColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyBadge(
                    value: xMessages.toString(),
                    //value: count.toString(),
                    top: -1,
                    right: -1,
                    //color: Colors.red,
                    child: Row(
                      children: const [
                        SizedBox(width: 5),
                        Text(
                          "Need help? click here  ",
                          style: TextStyle(color: Colors.white,fontSize: 15),
                        ),
                        Icon(Icons.chat, color: Colors.white,size: 30,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  buildBadge0(String type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed:type == 'x'? () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"x",receiverId: 0,)));
            setState(() {});
          }:type == 'r'?() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
            setState(() {});
          }:() {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)));
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColors().mainThemeColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                      children: const [
                        SizedBox(width: 5),
                        Text(
                          "Need help? click here  ",
                          style: TextStyle(color: Colors.white,fontSize: 15),
                        ),
                        Icon(Icons.chat, color: Colors.white,size: 30,),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  buildBadge1(String type) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if(type == 'e')
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)),
              );
            }
         else if(type == 'r')
           {
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
           }
        },
        child: MyBadge(
          value: type == 'e'?eMessages.toString():type == 'r'?rMessages.toString():"0",
          //value: count.toString(),
          top: -1,
          right: -1,
          color: Colors.red,
          child: AnimateIcon(
            key: UniqueKey(),
            onTap: () {
              if(type == 'e')
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)),
                );
              }
              else if(type == 'r')
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
              }
            },
            iconType:IconType.continueAnimation,
            height: 30,
            width: 30,
            color: Colors.white,
            animateIcon: AnimateIcons.chatMessage,
          ),
        ),
      ),
    );
  }
  buildBadge2(String type) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if(type == 'e')
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)),
            );
          }
          else if(type == 'r')
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
          }
        },
        child: AnimateIcon(
          key: UniqueKey(),
          onTap: () {
            if(type == 'e')
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"e", receiverId: 0,)),
              );
            }
            else if(type == 'r')
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatView(oid: order.orderId,receiverType:"r", receiverId: rider.riderId,)));
            }
          },
          iconType:IconType.onlyIcon,
          height: 30,
          width: 30,
          color: Colors.white,
          animateIcon: AnimateIcons.chatMessage,
        ),
      ),
    );
  }
}


