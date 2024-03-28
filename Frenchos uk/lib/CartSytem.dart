import 'dart:async';
import 'package:yoracustomer/widgets/LoaderDialog1.dart';
import '../LinkFiles/CustomColors.dart';
import 'package:yoracustomer/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'HomePage.dart';
import 'Model/Order.dart';
import 'Model/OrderItem.dart';
import 'ReviewDetail.dart';

///TODO: This is Cart View, This is Cart.

class CartSytem extends StatefulWidget {
  const CartSytem({Key? key}) : super(key: key);

  @override
  State<CartSytem> createState() => _CartSytemState();
}

class _CartSytemState extends State<CartSytem> {
  List<OrderItem>? iems = [];
  double? total = 0;
  String deliveryfee = "0";
  String tax = "0";
  String subtotal = "0";
  var listofcount;
  Order? orderDtl;
  TextEditingController instruction = TextEditingController();

  bool pageLoaded = false;
  bool plusLoading = false;
  bool minusLoading = false;
  final double width = 0.73;

  int index = 1;
  int index1 = 0;
  int selectedRadio = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //listofcount = iems!.length;
    getdetail(Globle.OrderId.toString());
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press event here.
        // Return true if you want to allow the back button press,
        // or false if you want to block the back button press.
        // For example, to block the back button press if a dialog is open:
        if (!Globle.OrderGenerated && Globle.OrderId == 0) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Homepage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: CustomColors().mainThemeColor,
          centerTitle: true,
          title: Text(
            "Cart",
            style: TextStyle(color: CustomColors().mainThemeTxtColor),
          ),
        ),
        body: Visibility(
          visible: pageLoaded,
          replacement: Center(child: LoaderDialog1()),
          child: Stack(children: [
            buildTopWidget(), // list of data availbale widget
            // here is positioned its means total
          ]),
        ),
      ),
    );
  }

  Future<void> getdetail(String orderId) async {
    iems = await itemscontroller().cartApi();

    orderDtl = await itemscontroller().orderDetailsMethod(orderId);
    deliveryfee = orderDtl!.deliveryCharges.toString();
    print("Printing delivery charges from Cart View, deliveryCharges => ${orderDtl!.deliveryCharges.toString()}");
    tax = orderDtl!.tax.toString();
    subtotal = (orderDtl!.productsAmount - orderDtl!.discount).toString();

    print("wwwwwwww"+subtotal.toString());

    var t =
        orderDtl!.tax + orderDtl!.productsAmount + orderDtl!.deliveryCharges;
    total = t;
    if (orderDtl!.orderId > 0) {
      pageLoaded = true;
      if (mounted) setState(() {});
    } else {
      Globle().goBackToHome(context);
      //getdetail(Globle.OrderId.toString());
    }
  }

  Future<void> countplus(int itemId) async {
    try {
      listofcount = await itemscontroller().Addcount(itemId);
      getdetail(Globle.OrderId.toString());
      plusLoading = false;
    } catch (e) {}
  }

  Future<void> countminus(int itemId) async {
    try {
      listofcount = await itemscontroller().Minuscount(itemId);
      getdetail(Globle.OrderId.toString());
      minusLoading = false;
    } catch (e) {}
  }

  Widget buildTopWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/BG1.jpg'),
        fit: BoxFit.cover,
      )),
      //height: MediaQuery.of(context).size.height * 0.55,
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
            ))
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(
                      height: 470,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: iems!.length,
                        // physics: FixedExtentScrollPhysics(),
                        itemBuilder: (context, index) {
                          final itemdate = iems![index];
                          print("iems![index].item!.price");
                          print(itemdate.item!.price * itemdate.qty);
                          print(itemdate.item!.discount);
                          return Card(
                            color: const Color.fromRGBO(255, 239, 238, 1.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading:
                                      itemdate.item!.imgUrl == "NotFound.png"
                                          ? Image.network(
                                              Globle.defaultImgPath,
                                              fit: BoxFit.cover,
                                              width: 70,
                                            )
                                          : Image.network(
                                              Globle.itemImgPath +
                                                  itemdate.item!.imgUrl,
                                              fit: BoxFit.cover,
                                              width: 70,
                                            ),
                                  title: Text(
                                    itemdate.item?.name ?? "name",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: itemdate.item!.price > 0 && itemdate.item!.discount == 0
                                      ? Text(
                                          Globle.showPrice(itemdate.item!.price * itemdate.qty),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      : itemdate.item!.discount > 0? Text(
                                    Globle.showPrice(
                                        (itemdate.item!.discount) *
                                            itemdate.qty),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ):const Text(""),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Stack(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              countminus(itemdate.item!.itemId);

                                              setState(() {
                                                minusLoading = true;
                                              });
                                            },
                                          ),
                                          Visibility(
                                            visible: minusLoading,
                                            child: const Positioned.fill(
                                              child: Center(
                                                child: Text(""),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        itemdate.qty.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Stack(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              //itemdate.qty += 1;
                                              countplus(itemdate.item!.itemId);
                                              setState(() {
                                                plusLoading = true;
                                              });
                                            },
                                          ),
                                          Visibility(
                                            visible: plusLoading,
                                            child: const Positioned.fill(
                                              child: Center(
                                                child: Text(""),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: itemdate.itemVerities!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: Text(
                                                  itemdate.itemVerities![index]
                                                      .name,
                                                  style: pkrStyle,
                                                ),
                                              ),
                                              Text(
                                                Globle.showPrice((itemdate.itemVerities![index].addPrice * itemdate.qty).toDouble()),
                                                style: pkrStyle,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
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
                  ),
                  Flexible(
                    flex: 0,
                    child: Container(
                      color: const Color.fromRGBO(255, 213, 128, 0.6),
                      //color: Colors.white,
                      //height: 280,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextField(
                              controller: instruction,
                              decoration: const InputDecoration(
                                label: Text("Any other instruction"),
                                //border: OutlineInputBorder(),
                                hintText: 'Optional',
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RadioMenuButton(
                                  value: index,
                                  groupValue: selectedRadio,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedRadio = val!;
                                      //index = val;
                                    });

                                    //print(vg.selectedRadioId);
                                  },
                                  child: const Text(
                                    "Delivery",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  //activeColor: Colors.blue,
                                ),
                                RadioMenuButton(
                                  value: index1,
                                  groupValue: selectedRadio,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedRadio = val!;
                                      /*index = val;
                                      print(selectedRadioId);*/
                                    });

                                    //print(vg.selectedRadioId);
                                  },
                                  child: const Text(
                                    "Collection",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ]),
                          //const SizedBox(height: 20),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));
                              },
                              child: const Text(
                                "Add more items",
                                style: TextStyle(color: Colors.red),
                              )),
                          //SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * width,
                                  child: ReusableText(
                                    text: "Subtotal",
                                    textAlign: TextAlign.start,
                                    alimnt: Alignment.topLeft,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Globle.showPrice(double.parse(subtotal)),
                                  textAlign: TextAlign.start,
                                  style: pkrStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 50,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    color: CustomColors().mainThemeColor,
                                    child: TextButton(
                                      onPressed: () async {
                                        Globle.instruction = instruction.text;
                                        if (iems!.isEmpty) {
                                          Globle()
                                              .Errormsg(context, "Cart Empty");
                                        } else {
                                          if (selectedRadio == 0) {
                                            int sc = await itemscontroller()
                                                .updateOrderType(
                                                    orderDtl!.orderId, false);
                                          } else {
                                            int sc = await itemscontroller()
                                                .updateOrderType(
                                                    orderDtl!.orderId, true);
                                          }

                                          /*var list = await itemscontroller().Getdeliveries();
                                            if (list.length == 0) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ReviewDetail("")));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => deliveryoption()));
                                            }*/

                                          print("gggggggggg"+subtotal);
                                          print("ccccccc"+Globle.minimumOrder.toString());
                                          if (double.parse(subtotal) >=
                                              Globle.minimumOrder.toDouble()) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReviewDetail("")));
                                          } else {
                                            Globle().Errormsg(context,
                                                "Minimum order amount is ${Globle.showPrice(Globle.minimumOrder.toDouble())}");
                                          }

                                          setState(() {});
                                        }
                                      },
                                      child: const Text(
                                        "Final Payment and Address",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
