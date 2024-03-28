import 'dart:convert';
import 'package:yoracustomer/Controller/AuthenticationRepository.dart';
import 'package:yoracustomer/loading_screen.dart';

import '../LinkFiles/CustomColors.dart';

import 'package:flutter/material.dart';
import 'package:yoracustomer/Model/Restaurant.dart';
import 'package:yoracustomer/bankaccountdetail.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:yoracustomer/widgets/CustomButton.dart';
import 'package:yoracustomer/widgets/CustomText.dart';
import 'package:yoracustomer/widgets/LoadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'Model/Customer.dart';
import 'Model/Order.dart';
import 'Model/OrderItem.dart';

class Confirmation extends StatefulWidget {
  const Confirmation(
      {Key? key,
        required this.bid,
        required this.instruction,
        required this.tax,
        required this.onCash})
      : super(key: key);
  final int bid;
  final double tax;
  final String instruction;
  final bool onCash;

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  List<OrderItem>? iems = [];
  final double width = 0.73;
  double? total = 0;
  ///Declaring Deliveryfee Variable.
  double deliveryfee = 0;
  String? tax = "0";
  String? subtotal = "0";
  var listofcount;
  Order orderDtl = Order(dateAdded: DateTime.now(), dispatchTime: DateTime.now(), deliveryTime: DateTime.now(), preparationTime: DateTime.now(), customer: Customer(dateAdded: DateTime.now()));
  Customer customer = Customer(dateAdded: DateTime.now());

  bool plusLoading = false;
  bool loadPage = false;
  bool minusLoading = false;
  ///isLoading bool to show inplace of proceed button on press
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail(Globle.OrderId.toString());
    setState(() {});
  }

 // Future generateCustomerOrder () async {
 //
 // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: CustomColors().mainThemeColor,
            centerTitle: true,
            title: Text("Final Review",style: TextStyle(color: CustomColors().mainThemeTxtColor),)),
        body: Visibility(
          visible: loadPage,
          replacement: const Center(
              child: LoadingWidget(
                msg: '',
              )),
          child: Stack(children: [
            //const SizedBox(height: 10,),
            buildTopWidget(), // list of data available widget
            Positioned(
              top: MediaQuery.of(context).size.height - 410,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //SizedBox(height: 60,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Expanded(
                            child: Text(
                              customer.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.call),
                          Text(
                            customer.secondaryContact,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * width,
                            child: ReusableText(
                              text: "Subtotal",
                              textAlign: TextAlign.start,
                              alimnt: Alignment.topLeft,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            Globle.showPrice(double.parse(subtotal!)),
                            textAlign: TextAlign.start,
                            style: pkrStyle,

                          ),
                        ],
                      ),
                    ),
                    ///Showing Delivery fee.
                    if (deliveryfee > 0) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                        //Delivery fee Row
                        child: Row(
                                children: [
                                  SizedBox(
                                    // width:
                                    //     MediaQuery.of(context).size.width * width,
                                    child: ReusableText(
                                      text: "Delivery Fee",
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.start,
                                      alimnt: Alignment.topLeft,
                                    ),
                                  ),
                                  Spacer(),
                                  ///Showing Delivery fee
                                  Text(
                                    Globle.showPrice(deliveryfee),
                                    textAlign: TextAlign.start,
                                    style: pkrStyle,
                                  ),
                                ],
                              ),
                      ),
                    ],
                    if (tax != "0") ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.73,
                              child: ReusableText(
                                text: "Total Tax",
                                textAlign: TextAlign.start,
                                alimnt: Alignment.topLeft,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              Globle.showPrice(double.parse(tax!)),
                              textAlign: TextAlign.start,
                              style: pkrStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (orderDtl.discount > 0) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.73,
                              child: ReusableText(
                                text: "Discount",
                                textAlign: TextAlign.start,
                                alimnt: Alignment.topLeft,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              Globle.showPrice(orderDtl.discount),
                              textAlign: TextAlign.start,
                              style: pkrStyle,
                            ),
                          ],
                        ),
                      ),
                    ],

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: total.toString() == "0"
                          ? null: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.73,
                            child: ReusableText(
                              text: "Total (incl. VAT)",
                              textAlign: TextAlign.start,
                              alimnt: Alignment.topLeft,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            Globle.showPrice(total!),
                            textAlign: TextAlign.start,
                            style: pkrStyle,
                          ),
                        ],
                      ),
                    ),
                    /*const SizedBox(
                      height: 5,
                    ),*/
                    /// LoadingScreen is Show when Proceed Button is pressed, with loader widget is below as Original.
                    Container(
                        height: 50,
                        //width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: CustomColors().mainThemeColor, width: 2.0)),
                        child: ReusableButton(
                          text: 'Proceed',
                          onPressed: () async {
                            ///For showing Loader on-press
                            // setState(() {
                            //   isLoading == true; // Show loading indicator
                            // });

                            if (orderDtl.orderType == true) {
                              if (orderDtl.deliveryCharges > 40) {
                                //OnCash = code 22.
                                if (widget.onCash) {
                                  // if(isLoading == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoadingScreen()));
                                  // }
                                  int sc = await AuthenticationRepository()
                                      .updateDeliveryCharges(
                                      Globle.OrderId, deliveryfee.toString());
                                  ///If updateDeliveryCharges successfull then generate order
                                  if (sc == 200) {
                                    print("updateDeliveryCharges Successful------------------------->");
                                    // itemscontroller().GenerateOrders("Type", Order Instructions);
                                    ///fix : generateOrders is sending notification of new order to Operator app.
                                    ///Fixed, noved notification below insted of in denerateOrders
                                    sc = await itemscontroller().GenerateOrders("c", widget.instruction);
                                    if(sc == 200){
                                      /// TODO:  SENDING NOTIFICATION------------------------------------->
                                      /// Send notification to Rider
                                      AuthenticationRepository().sendNotificationToRiders(orderDtl.fkRestaurantId);
                                      ///Send notification to Operator
                                      itemscontroller().SendNotificationToOperator();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => paymentdetail(
                                                  oid: int.parse(
                                                      Globle.OrderId.toString()),
                                                  widget.instruction)));
                                    }
                                   else{
                                     Globle().Errormsg(context, "Error, please try again");
                                    }
                                  }
                                }
                                else {
                                  await AuthenticationRepository()
                                      .updateDeliveryCharges(
                                      Globle.OrderId, deliveryfee.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => bankaccountdetail(
                                              widget.bid, widget.instruction)));
                                }
                              }
                              else {
                                Globle().Errormsg(context, "Error, please try again");
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Confirmation(
                                              bid: widget.bid,
                                              instruction: '',
                                              tax: widget.tax,
                                              onCash: widget.onCash,
                                            )));
                              }
                              // After your logic is done, set isLoading back to false.
                              // setState(() {
                              //   isLoading = false;
                              // });
                            }
                          },
                          colors: CustomColors().mainThemeColor,
                          styl: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ///Original with loading gif
                    // Visibility(
                    //   visible: !isLoading,
                    //   replacement: Center(child: SizedBox(
                    //       height: 40,
                    //       child: LoadingWidget(msg: "Please wait")),),
                    //   child: Container(
                    //     height: 50,
                    //     //width: 120,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         border: Border.all(color: CustomColors().mainThemeColor, width: 2.0)),
                    //     child: ReusableButton(
                    //       text: 'Proceed',
                    //       onPressed: () async {
                    //         ///For showing Loader on-press
                    //         setState(() {
                    //           isLoading = true; // Show loading indicator
                    //         });
                    //
                    //         if (orderDtl.orderType == true) {
                    //           if (orderDtl.deliveryCharges > 40) {
                    //             //OnCash = code 22.
                    //             if (widget.onCash) {
                    //               // Updating Delivery fee, updateDeliveryCharges requires(int oid, String charges)
                    //               print("Updating Delivery fee with updateDeliveryCharges function------------------>");
                    //               print("OrderID:=> ${Globle.OrderId} Delivery Charges:=> ${deliveryfee.toString()}");
                    //               int sc = await AuthenticationRepository()
                    //                   .updateDeliveryCharges(
                    //                   Globle.OrderId, deliveryfee.toString());
                    //               ///If updateDeliveryCharges successfull then generate order
                    //               if (sc == 200) {
                    //                 // itemscontroller().GenerateOrders("Type", Order Instructions);
                    //                 sc = await itemscontroller().GenerateOrders("c", widget.instruction);
                    //                 if(sc == 200){
                    //                   // SEND NOTIFICATION
                    //                   AuthenticationRepository().sendNotificationToRiders(orderDtl.fkRestaurantId);
                    //                   // End
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) => paymentdetail(
                    //                               oid: int.parse(
                    //                                   Globle.OrderId.toString()),
                    //                               widget.instruction)));
                    //                 }
                    //                else{
                    //                  Globle().Errormsg(context, "Error, please try again");
                    //                 }
                    //               }
                    //             }
                    //             else {
                    //               await AuthenticationRepository()
                    //                   .updateDeliveryCharges(
                    //                   Globle.OrderId, deliveryfee.toString());
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => bankaccountdetail(
                    //                           widget.bid, widget.instruction)));
                    //             }
                    //           }
                    //           else {
                    //             Globle().Errormsg(context, "Error, please try again");
                    //             Navigator.pop(context);
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => Confirmation(
                    //                           bid: widget.bid,
                    //                           instruction: '',
                    //                           tax: widget.tax,
                    //                           onCash: widget.onCash,
                    //                         )));
                    //           }
                    //           // After your logic is done, set isLoading back to false.
                    //           setState(() {
                    //             isLoading = false;
                    //           });
                    //         }
                    //       },
                    //       colors: CustomColors().mainThemeColor,
                    //       styl: const TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 20),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  getDeliveryCharges(){

  }

  Future<void> getDetail(String orderId) async {
    iems = await itemscontroller().cartApi();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Globle.waitingTime = 0;
    var cus = preferences.getString("user");
    var res = preferences.getString("restaurant");
    customer = Customer.fromJson(jsonDecode(cus!));
    Restaurant restaurant = Restaurant.fromJson(jsonDecode(res!));
    customer = await itemscontroller().getCustomer(customer.contact);

    orderDtl = await itemscontroller().orderDetailsMethod(orderId);
    ///Updating Customer order details
    if(!orderDtl.orderType)
    {
      customer.address = restaurant.address;
      customer.contact = restaurant.primaryContact;
      deliveryfee = orderDtl.deliveryCharges;
    }
    else{
      ///Not on cash = 21
      int code = 21;
      ///On Cash = 22
      if(widget.onCash){
        code = 22;
      }
      deliveryfee = orderDtl.deliveryCharges;   /// this is delivery charges without bykea if you want to on below code bykea code then comment this code
      //getDeliveryCharges();

      /// this code will be used for bykea if you want to on please uncomment below code
      // var fare = await AuthenticationRepository().fareEstimate(code,restaurant.latitude.toString(),restaurant.longitude.toString() ,customer.latitude.toString(),customer.longitude.toString());
      // if(fare.data.fareEst.toDouble() > orderDtl.deliveryCharges) {
      //   orderDtl.deliveryCharges = deliveryfee = (fare.data.fareEst.toDouble() + 10.0);
      // }
      // else{
      //   deliveryfee = orderDtl.deliveryCharges;
      // }
    }
    tax = orderDtl.tax.toStringAsFixed(0);
    subtotal = orderDtl.productsAmount.toString();
    var t = orderDtl.tax +
        orderDtl.productsAmount +
        orderDtl.deliveryCharges - orderDtl.discount;
    total = t;
    loadPage = true;
    if (mounted) setState(() {});
  }

  Widget buildTopWidget() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BG1.jpg'),
              fit: BoxFit.cover,
            )),
        height: MediaQuery.of(context).size.height - 410,
        child: iems == null
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 100,
              ),
              Text(
                "Cart is Empty",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: iems!.length,
          // physics: FixedExtentScrollPhysics(),
          itemBuilder: (context, index) {
            final itemdate = iems![index];
            return Card(
              color: const Color.fromRGBO(255, 239, 238, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: itemdate.item!.imgUrl == "NotFound.png"
                        ? Image.network(
                      Globle.defaultImgPath,
                      fit: BoxFit.cover,
                      width: 70,
                    )
                        : Image.network(
                      Globle.itemImgPath + itemdate.item!.imgUrl,
                      fit: BoxFit.cover,
                      width: 70,
                    ),
                    title: Text(
                      itemdate.item?.name ?? "name",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle:itemdate.item!.price > 0 && itemdate.item!.discount == 0? Text(
                      Globle.showPrice(itemdate.item!.price * itemdate.qty),
                      style: pkrStyle,
                    ):itemdate.item!.discount > 0 ? Text(
                      Globle.showPrice(itemdate.item!.discount * itemdate.qty),
                      style: pkrStyle,
                    ):const Text(""),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 17.0),
                      child: Text(
                        itemdate.qty.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemdate.itemVerities!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * width,
                                  child: Text(
                                    itemdate.itemVerities![index].name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),

                                Text(
                                  Globle.showPrice((itemdate.itemVerities![index].addPrice * itemdate.qty).toDouble()),
                                  style: pkrStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Text(
                      itemdate.itemInstruction,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
