import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:yoracustomer/widgets/LoaderDialog.dart';
import 'package:yoracustomer/widgets/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller/AuthenticationRepository.dart';
import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'LinkFiles/CustomColors.dart';
import 'Model/Banner.dart';
import 'Model/Customer.dart';

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

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String res = "565656";
  Customer customer = Customer(dateAdded: DateTime.now());

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
    sendOtpCode();
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


  sendOtpCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString("user");
    customer = Customer(dateAdded: DateTime.now());
    if (user != null) {
      try {
        customer = Customer.fromJson(jsonDecode(user));
        if (customer.customerId > 0) {
          if(customer.contact == Globle.countryCode + Globle.testingNumber)
          {
            res = "565656";
          }
          else
          {
            //res = await AuthenticationRepository().verifyPhoneNumber(customer.contact.substring(2));
            Random random = Random();
            // Generate a random number in the specified range
            res = (100000 + random.nextInt(999999 - 100000 + 1)).toString();
          }
          Globle().Succesmsg(context, "OTP has been sent to your number");
        } else {}
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
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
              )),
          child: Visibility(
            visible: pageLoaded,
            replacement: const Center(
                child: LoadingWidget(
                  msg: "",
                )),
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
                            return value == res ? null : 'Pin is incorrect';
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
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(19),
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
                    color: Colors.red,
                    child: TextButton(
                      onPressed: () async {
                        focusNode.unfocus();
                        formKey.currentState!.validate();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const LoaderDialog("");
                            });
                        if (res == VerifyOtp.text) {
                          customer.deletedDate = DateTime.now();
                          customer.name = "";
                          customer.fkAreaId = 0;
                          customer.fkCityId = 0;
                          customer.address = "";
                          customer.landmark = "";
                          customer.secondaryContact = customer.contact;
                          customer.email = "";
                          customer.isDeleted = true;
                          int sc =
                          await itemscontroller().updateprofile(customer);
                          if (sc == 200) {
                            Globle().Succesmsg(context, "Account deleted successfully");
                            Globle.customerid = 0;
                            Globle.customerName = "";
                            Globle.customerNumber = "";
                            Globle.OrderId = 0;
                            Globle.bannerDataList = [];
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            preferences.clear();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/splash',
                                  (Route<dynamic> route) => false,
                            );
                          } else {
                            Globle().Errormsg(context,
                                "Server error, Please try again later");
                          }
                        }
                        else {
                          Navigator.pop(context);
                          String msg = "Please enter your OTP";
                          Globle().Errormsg(context, msg);
                        }
                      },
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(
                          color: Colors.black,),
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
                                text: res,
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

  void loadPage() {
    _timer = Timer(const Duration(seconds: 3), () async {
      setState(() {
        pageLoaded = true;
      });
    });
    setState(() {});
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

}
