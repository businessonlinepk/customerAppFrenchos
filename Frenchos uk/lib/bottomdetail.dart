import 'package:yoracustomer/Controller/itemscontroller.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yoracustomer/Model/Item.dart';
import '../LinkFiles/CustomColors.dart';

import 'Controller/AuthenticationRepository.dart';
import 'Controller/VerityGroupsController.dart';
import 'EmailVerify.dart';
import 'Homepage.dart';
import 'Model/Order.dart';
import 'Model/VerityGroup.dart';
import 'LinkFiles/EndPoints.dart';

class bottomdetail extends StatefulWidget {
   const bottomdetail( {Key? key,required this.itemId }) : super(key: key);
  //final String name,price,imgurl, des;
  final int itemId;


  @override
  State<bottomdetail> createState() => _bottomdetailState();
}

class _bottomdetailState extends State<bottomdetail> {
  TextEditingController instruction = TextEditingController( );
  //String instruction = "";
/*  int _selectedIndex=0;
  int _n = 0;

 bool _isChecked = true;*/

  TextEditingController sendOtp = TextEditingController();
  Order? createOrderLst;
  Item item = Item(name: "", description: "", price: 0, dateAdded: DateTime.now());
  List<VerityGroup>? verityGroups= [];
  var radiocheck;
  bool _isButtonDisabled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemDetail();
    veritydetail();
   //radiomethod(Globle.ProductId);
    instruction.text = "";

  }
  int? selectedRadio;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      // debugShowCheckedModeBanner: false,
      child: Scaffold(
        body: SingleChildScrollView(

          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            children: [
              Column(
                children: [
                  item.imgUrl == "NotFound.png"? Image.network(Globle.defaultImgPath,height: 230,width:double.infinity,fit: BoxFit.cover,): Image.network(Globle.itemImgPath+item.imgUrl,height: 230,width:double.infinity,fit: BoxFit.cover,),
                  const SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.66,
                            child: Text(
                              item.name.length < 29
                                  ? item.name
                                  : "${item.name.substring(0, 29)}...",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                        if (item.price > 0 && item.discount == 0) ...[
                          Text(Globle.showPrice(item.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ]else if(item.discount > 0) ...[
                          Text(Globle.showPrice(item.discount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),

                  const SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 8),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(item.description.trim(), style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black54),)),
                  ),
                  const SizedBox(height: 7,),
                  const Divider(),
                  if(verityGroups != null && verityGroups!.isNotEmpty)...[
                    SingleChildScrollView(
                      child: Card(
                        // color: Colors.greenAccent ,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              // Text("data"),

                              for(var vg in verityGroups!)...[

                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0,left: 5.0,right: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(vg.groupName,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                      if(vg.groupType)...[
                                        const Text("required", style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold)),
                                      ]else ...[
                                        const Text("optional", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                                      ]
                                    ],
                                  ),
                                ),
                                if(vg.groupType )...[
                                  //radio buttons
                                  // Text("data"),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                      // elevation:5,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          children: vg.verities!.asMap().entries.map((entry) {
                                            int index = entry.value.itemVerityId;
                                            String item = entry.value.name;
                                            String price = entry.value.addPrice.toString();
                                            return  Container(
                                              height: 50,
                                              // color: Color.fromRGBO(218, 208, 208, 0.9),
                                              // color: Colors.fromARGB(255, 153, 255, 0.9),
                                              color: const Color.fromRGBO(255, 153, 255, 0.2),
                                              // color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.65,
                                                      child: RadioMenuButton(
                                                        value: index,
                                                        groupValue:vg.selectedRadioId,
                                                        onChanged: (val) {
                                                          /// If new user/Customer then show Login
                                                          if (Globle.customerid <= 0) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: const Text("Verification"),
                                                                content: logIn(context),
                                                              ),
                                                            );
                                                          }else{
                                                            setState(() {
                                                              vg.selectedRadioId = val!;
                                                              index = val;
                                                            });
                                                          }
                                                        },

                                                        child:item.length > 24? Text(
                                                          "${item.substring(0,24)} ...",
                                                          style: const TextStyle(
                                                              fontSize: 14),

                                                        ):Text(
                                                          item,
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15.0,right: 6),
                                                      child: Text(Globle.showPrice(double.parse(price)),style: const TextStyle(fontSize: 16),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                                else...[
                                  //check boxes
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Card(
                                      // elevation:5,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          children: vg.verities!.asMap().entries.map((entry) {
                                            int index = entry.key;
                                            String item = entry.value.name;
                                            String price = entry.value.addPrice.toString();
                                            return Container(
                                              height: 50,
                                              // color: Color.fromRGBO(218, 208, 208, 0.1),
                                              color: const Color.fromRGBO(255, 153, 255, 0.2),
                                              // color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.65,
                                                      child:CheckboxMenuButton(
                                                        value:  vg.verities![index].status,
                                                        onChanged:(bool? newValue) {
                                                          ///If new user/Customer then show Login
                                                          if (Globle.customerid <= 0) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: const Text("Verification"),
                                                                content: logIn(context),
                                                              ),
                                                            );
                                                          }else{
                                                            setState(() {
                                                              vg.verities![index].status = newValue!;
                                                            });
                                                            radiomethod(vg.verities![index].itemVerityId,newValue!);
                                                          }

                                                        },
                                                        child:item.length > 24? Text(
                                                          "${item.substring(0,24)} ...",
                                                          style: const TextStyle(
                                                              fontSize: 14),

                                                        ):Text(
                                                          item,
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15.0,right: 6),
                                                      child: Text(Globle.showPrice(double.parse(price)),
                                                        style: const TextStyle(fontSize: 16),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                Container(
                                  color: Colors.white,
                                  child: const SizedBox(
                                    height: 10,

                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Special instructions", style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),)),
                  ),
                  const SizedBox(height: 6,),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0,right: 16.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Please let us know if you are allergic to anything or if we need to avoid anything")),
                  ),
                  const SizedBox(height: 10,),

                   Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 8,top: 8),
                    child: TextField(
                      controller: instruction,
                      style: const TextStyle(height: 1,fontSize: 18),
                      //controller: instruction,
                      // obscureText: true,
                      decoration: const InputDecoration(
                        // fillColor: Colors.white,
                        filled: true,

                        contentPadding: EdgeInsets.symmetric(vertical: 17,horizontal: 10),

                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     // color: Colors.red,
                        //
                        //   ),
                        //
                        // ),

                        labelText:"Optional" ,
                        hintText: "e.g. no mayo",

                        border: OutlineInputBorder(

                          borderSide: BorderSide(color: Colors.grey),

                        ),


                      ),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 8),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: CustomColors().mainThemeColor,
                        ///Add to Cart Button
                        child: TextButton(
                            onPressed: () async {
                             bool check  = false;
                             int count = 0;
                             for(int i = 0 ; i < verityGroups!.length ; i++){
                               if(verityGroups![i].groupType && verityGroups![i].selectedRadioId > 0)
                                 {
                                   check = true;
                                   count++;
                                   //print("Count1 ${count}");
                                   //print("check ${check}");
                                 }
                               else if(verityGroups![i].groupType && verityGroups![i].selectedRadioId == 0)
                                 {
                                   count++;
                                   check = false;
                                   //print("Count2 ${count}");
                                  // print("check ${check}");
                                   break;

                                 }
                             }
                             if(count == 0 ){
                               check = true;
                               //print("Count3 ${count}");
                               //print("check ${check}");
                              }
                             if(check)
                               {
                                 ///If new user/Customer then show Login
                                 if (Globle.customerid <= 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Verification"),
                                      ///Showing LogIn if new user
                                      content: logIn(context),
                                    ),
                                  );
                                  print("New User, has shown the Number verify LogIn box--------------->");
                                } else
                                   {
                                     createOrderLst = await itemscontroller()
                                         .createorder(Globle.customerid.toString(),
                                         EndPoints.Resturantid.toString(), widget.itemId,instruction.text);
                                     itemscontroller().sendGroupVerities(widget.itemId,verityGroups!);
                                     Globle.OrderId =
                                         createOrderLst!.orderId;

                                     Navigator.pop(context);
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) => Homepage()));
                                     Fluttertoast.showToast(
                                         msg: "Product added to cart",
                                         toastLength: Toast.LENGTH_LONG,
                                         gravity: ToastGravity.TOP,
                                         timeInSecForIosWeb: 3,
                                         backgroundColor: CustomColors().secondThemeColor,
                                         textColor: CustomColors().secondThemeTxtColor,
                                         fontSize: 16.0);
                                   }
                               }
                             else
                               {
                                 String msg="Please select all required values";
                                 Globle().Errormsg(context,msg);
                               }

                            },
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(color:CustomColors().mainThemeTxtColor ),
                            ))),
                  )
                ],
              ),

              Positioned(
                // bottom: 0,
                  top: 50,
                  left: 6,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Homepage()));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );

  }

  SizedBox logIn(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please enter your number",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: sendOtp,
              maxLength: Globle.numCount,
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
                onPressed: _isButtonDisabled ? null : () async {
                  setState(() {
                    _isButtonDisabled = true; // Disable the button
                  });
                  String res = "565656";
                    String msg = "OTP has been sent to your number";
                    if (sendOtp.text.length != Globle.numCount) {
                      Globle().Errormsg(context,
                          "Invalid number");
                    }
                    else if (sendOtp.text == Globle.testingNumber) {
                      Globle().Succesmsg(context, msg);
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) {
                            return  EmailVerify(res: res, sendOtp: sendOtp.text,pid: widget.itemId);
                          }));
                    }
                    else if (sendOtp.text.isEmpty) {
                      Globle().Errormsg(context, "Please enter your Number");
                    }
                    else {
                      res = await AuthenticationRepository()
                          .verifyPhoneNumber(sendOtp.text);

                      Globle().Succesmsg(context, msg);
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) {
                            return  EmailVerify(res: res, sendOtp: sendOtp.text,pid: widget.itemId);
                          }));
                    }

                },
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(color: Colors.white),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> veritydetail() async {
    try{
      verityGroups = await VerityGroupsController().getVerityGroups(widget.itemId);
    } catch (e) {

    }
    setState(() {

    });
    // if (mounted) setState(() {});

  }
  Future<void> itemDetail() async {
    try{
      item = await itemscontroller().getUser(widget.itemId);
      if(item.discount > 0)
        {
          item.discount = item.price *(100 - item.discount) / 100;
        }
      /*if(widget.price == "0")
        {
          item = await itemscontroller().getUser(widget.itemId);
        }
      else
        {
          item.itemId = widget.itemId;
          item.name = widget.name;
          item.price = double.parse(widget.price);
          item.imgUrl = widget.imgurl;
        }*/
    } catch (e) {

    }
    setState(() {

    });
    // if (mounted) setState(() {});

  }

  void radiomethod(int vid, bool check) {
    try {

      radiocheck = itemscontroller().Radiobuttoncheck(widget.itemId,vid,check);
    } catch (e) {

    }
    setState(() {

    });
    if (mounted) setState(() {});
  }
}