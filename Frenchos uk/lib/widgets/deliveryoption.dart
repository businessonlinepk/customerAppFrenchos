import 'package:yoracustomer/Controller/itemscontroller.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../LinkFiles/CustomColors.dart';
import '../Model/Delivery.dart';
import '../ReviewDetail.dart';


class deliveryoption extends StatefulWidget {
  const deliveryoption({Key? key}) : super(key: key);

  @override
  State<deliveryoption> createState() => _deliveryoptionState();
}

class _deliveryoptionState extends State<deliveryoption> {
  List<Delivery> listofdeliveries = [Delivery(dateAdded: DateTime.now())];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      deliverieslist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text("Delivery option"),
    backgroundColor: CustomColors().mainThemeColor,
  ),
      body: Column(
        children: [
             Container(
               // height: 200,
               child: ListView.builder(
                  itemCount: listofdeliveries.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index ) {
                    return Column(
                      children: [
                        Card(
                          color: Colors.blueGrey, // set the color to blue
                          child: ListTile(

                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listofdeliveries[index].name, style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),),
                                  Text("${Globle.Currency} ${listofdeliveries[index].amount}",style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(listofdeliveries[index].message.toString(),style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),),
                              ],
                            ),
                            onTap: () async {

                              int sc = await itemscontroller().Selectdelivery(listofdeliveries[index].deliveryId);
                              if(sc == 200)
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder:
                                         (context) =>   ReviewDetail("")));
    }
                              else{
                                Globle().Errormsg(context, "Error");
                              }
                            },
                          ),
                        ),
                      ],
                    );

                  }


              ),)
          ],
        )
      );

  }

  Future<void> deliverieslist() async {
    try {
      listofdeliveries = await itemscontroller().Getdeliveries();
  } catch (e){
    }
    if(mounted) {
      setState(() {

    });
    }
  }

}
