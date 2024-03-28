import 'dart:io';
import '../LinkFiles/CustomColors.dart';

import 'package:yoracustomer/Controller/BankAccountsController.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/Model/BankAccount.dart';
import 'package:yoracustomer/Model/Payment.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:yoracustomer/widgets/CustomButton.dart';
import 'package:yoracustomer/widgets/CustomSizedBox.dart';
import 'package:yoracustomer/widgets/CustomText.dart';
import 'package:yoracustomer/widgets/LoaderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'Controller/itemscontroller.dart';

class bankaccountdetail extends StatefulWidget {
   bankaccountdetail(this.id, this.instruction);

  final int? id;
  final String instruction;
  @override
  State<bankaccountdetail> createState() => _bankaccountdetailState();
}

class _bankaccountdetailState extends State<bankaccountdetail> {
  TextEditingController bankname=TextEditingController();
  var GenerateOrdr;


  BankAccount? bankDetaiil;
  getAsync() async {
    try {
      bankDetaiil = await BankAccountsController().detailBankAccount(widget.id);
    } catch (e) {
      print(e);
    }

    if (mounted) setState(() {});
  }

  XFile? imageFile = null;

  final _picker = ImagePicker();
  var size, height, width;
  var maxLines = 5;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  void _openGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    // getImage(
    //   source: ImageSource.camera ,
    // );
    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      setState(() {});
      Navigator.pop(context);
    } else {
      print("no Image Selected");
    }
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    // getImage(
    //   source: ImageSource.camera ,
    // );
    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      setState(() {});
      Navigator.pop(context);
    } else {
      print("no Image Selected");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAsync();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(style: TextStyle(color: CustomColors().mainThemeTxtColor)," Bank Detail",),
        centerTitle: true,
        backgroundColor: CustomColors().mainThemeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0),
            //     border: Border.all(
            //         color: Colors.black,
            //         width: 6.0
            //     ),
            //     ),
            child: Column(
              children: [
                ReusableSizedBox(width: 0, height: 10),
                Column(
                  children: [
                    ReusableText(text: "Bank Name",textAlign: TextAlign.start, fontSize: 18,alimnt: Alignment.topLeft,fontWeight: FontWeight.bold,),
                    ReusableSizedBox(width: 10, height: 0),
                    ReusableText(text: bankDetaiil?.bankName ?? "-",textAlign: TextAlign.start,fontSize: 18,alimnt: Alignment.topLeft),
                  ],
                ),
                ReusableSizedBox(
                  width: 0,
                  height: 12,
                  // child: Text('Reusle Sized Box'),
                ),
                Column(
                  children: [
                    ReusableText(text: "Account Title",textAlign: TextAlign.start, fontSize: 18,alimnt: Alignment.topLeft,fontWeight: FontWeight.bold,),
                    ReusableSizedBox(width: 10, height: 0),
                    ReusableText(text: bankDetaiil?.accountTitle ?? "-",textAlign: TextAlign.start,fontSize: 18,alimnt: Alignment.topLeft),
                  ],
                ),
                ReusableSizedBox(
                  width: 0,
                  height: 12,
                  // child: Text('Reusle Sized Box'),
                ),
                Column(
                  children: [
                    ReusableText(text: "IBAN Number",textAlign: TextAlign.start, fontSize: 18, alimnt: Alignment.topLeft,fontWeight: FontWeight.bold,),
                    ReusableSizedBox(width: 10, height: 0),
                    ReusableText(text: bankDetaiil?.iban ?? "-",textAlign: TextAlign.start,fontSize: 18,alimnt: Alignment.topLeft),
                  ],
                ),
                ReusableSizedBox(
                  width: 0,
                  height: 12,
                  // child: Text('Reusle Sized Box'),
                ),
                Column(
                  children: [
                    ReusableText(text: "Instruction",textAlign: TextAlign.start, fontSize: 18, alimnt: Alignment.topLeft,fontWeight: FontWeight.bold,),
                    ReusableSizedBox(width: 10, height: 0),
                    ReusableText(text: bankDetaiil?.instruction ?? "-",textAlign: TextAlign.start,fontSize: 18,alimnt: Alignment.topLeft),
                  ],
                ),
                ReusableSizedBox(
                  width: 0,
                  height: 12,
                  // child: Text('Reusle Sized Box'),
                ),
                // imagepicker(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(text:"Upload Payment Slip",textAlign: TextAlign.start,alimnt: Alignment.topLeft,fontWeight: FontWeight.bold,),
                    // ReusableText(text:"Select here",textAlign: TextAlign.right,alimnt: Alignment.topRight),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: CustomColors().mainThemeColor,
                              width: 2.0
                          )
                      ),
                      // color: CustomColors().mainThemeColor,
                      height: 35,
                      // width: double.infinity,
                      child: ReusableButton(
                        text: 'Select here',
                        onPressed: () {
                          _showChoiceDialog(context);
                          setState(() {

                          });
                        }, colors: CustomColors().mainThemeColor, styl: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 2.3, //half of the height size
                  width: width, //half of the width size
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: SizedBox(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: (imageFile != null)
                                ? Image.file(
                              File(imageFile!.path),
                              width: width, //half of the width size
                              height: height /
                                  2, //25% of the height size
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: height /
                                  2.5, //25% of the height size
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://www.caspianpolicy.org/no-image.png"),
                                ),
                                // color: Colors.red,
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            // Text("Choose Image"): Image.file(File(imageFile!.path)),
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         right: 0.0,
                      //         left: 16.0,
                      //         top: 0.0,
                      //         bottom: 0.0),
                      //     child: MaterialButton(
                      //       textColor: Colors.white,
                      //       color: CustomColors().mainThemeColor,
                      //       onPressed: () {
                      //         _showChoiceDialog(context);
                      //       },
                      //       child: const Text("Select Image"),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                ReusableSizedBox(height: 20.0, width: 0,),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: CustomColors().mainThemeColor,
                          width: 2.0
                      )
                  ),
                  child: ReusableButton(
                    text: 'Submit',
                    onPressed: () async{
                      if(imageFile==null){
                        Fluttertoast.showToast(
                            msg: "Please upload receipt",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: CustomColors().secondThemeColor,
                            textColor: CustomColors().secondThemeTxtColor,
                            fontSize: 20,

                        );
                      }else{
                        submitPayment('n');
                      }

                     setState(() {

                     });
                    }, colors: CustomColors().mainThemeColor, styl: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      )

    );
  }

  //   Future _pickImage(BuildContext context) async {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.getImage(source: ImageSource.camera);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //       });
  //     }
  //   Future _pickImage(BuildContext context) async {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //       });
  //     }
  //   }
  //
  //
  // }


  Future<int> GenerteOrdrs(String type) async {
    int sc = 0;
    try {
      sc = await itemscontroller().GenerateOrders(type, widget.instruction);
    } catch (e) {}
    return sc;
  }

  Future<void> submitPayment(String type) async {
    String msg="Loading...";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return  LoaderDialog(msg);
        });
    int sc = await GenerteOrdrs(type);
    Payment p=Payment(dateAdded: DateTime.now());
    p.fkBankAccountId = bankDetaiil!.tId;
    int statusCode=await BankAccountsController().addPayment(p ,imageFile);
    print(statusCode);
    if(statusCode==200 && sc == 200){


      // Globle.OrderId="0";
      Navigator.of(context,
          rootNavigator: true)
          .pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => paymentdetail(
                  oid: int.parse(
                      Globle.OrderId.toString()),
                  widget.instruction)));
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return ReusableAlertDialog(
      //       title: "gloriajeans Payoment",
      //       content: "Your payment has been paid successfully",
      //       onOkPressed: (){
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) =>  Homepage()));
      //       },
      //     );
      //   },
      // );
      /*showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog();

        },
      );*/


    }else{
      Navigator.of(context,
          rootNavigator: true)
          .pop();
      Fluttertoast.showToast(
          msg: "error please try again",
          toastLength: Toast.LENGTH_LONG,
          fontSize: 20,
          textColor: Colors.green
      );
    }
    setState(()  {

    });
  }

/*  Widget MyAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://icons.iconarchive.com/icons/death-of-seasons/heart-bubble/256/heart-purple-3-icon.png",),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text("Thank for your\n         time!", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height: 20),
          Container(
              width: double.infinity,
              color: CustomColors().mainThemeColor,
              child: TextButton(onPressed: (){

                setState(() {
                  Navigator.of(context,
                      rootNavigator: true)
                      .pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId,)));
                });
              }, child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)))
        ],
      ),
    );
  }*/
}
