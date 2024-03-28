import '../LinkFiles/CustomColors.dart';

import 'package:yoracustomer/Controller/itemscontroller.dart';
import 'package:yoracustomer/Model/Order.dart';
import 'package:flutter/material.dart';

import 'ChatView.dart';
import 'GlobleVariables/Globle.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<Order>? history = [];

  final lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    CustomColors().mainThemeColor,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.purpleAccent,
    Colors.greenAccent.shade400,
    Colors.cyanAccent,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: CustomColors().mainThemeColor,
        title: Text(
          "Order history",
          style: TextStyle(color: CustomColors().mainThemeTxtColor),
        ),
      ),
      body: Card(
        color: Colors.white,
        elevation: 6,
        child: history!.length > 1 ? ListView.builder(
          itemCount: history!.length,
          itemBuilder: (context, index) {
            return Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                  top: 5,
                                  right: 4,
                                  left: 0,
                                  bottom: 0,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text(
                                        "Order no #" +
                                            history![index].orderId.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (history![index].orderStatus == "d") ...[
                                        const Text(
                                          "Completed",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ]
                                      else if (history![index].orderStatus == "c") ...[
                                        const Text(
                                          "Cancelled",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]
                                      else ...[
                                        Text(
                                          "New Order",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                CustomColors().mainThemeColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),

                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (history![index].paymentType == 'c') ...[
                                      const Text(
                                        'Payment type: ' "Cash",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ] else ...[
                                      const Text(
                                        'Payment type: ' "Online",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                    Text(
                        Globle.showPrice(history![index].productsAmount + history![index].tax +history![index].deliveryCharges - history![index].discount),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width,child: Container(
                                color: CustomColors().mainThemeColor,
                                child:TextButton(
                                    onPressed: ( ) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChatView(oid: history![index].orderId,receiverType:"x",receiverId: 0,)),
                                      );
                                    }
                                    , child: Text("Customer Support",style: TextStyle(color: CustomColors().mainThemeTxtColor,),textAlign: TextAlign.center,),
                                ),
                              ),),
                            ],
                          ),
                        ),
                      ),
                    );
          },
        )
            :
            const Center(
              child: Text("You don't have any previous orders"),
            )
        ,
      ),
    );
  }

  Future<void> getHistory() async {
    try {
      history = await itemscontroller().Userhistory();
      setState(() {
        history = history!.where((element) => element.orderGenrated == true).toList();
      });
    } catch (e) {}
  }

}
