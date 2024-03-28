/*
import 'dart:convert';
import '../LinkFiles/CustomColors.dart';
import 'package:yoracustomer/OTPNumber.dart';
import 'package:yoracustomer/widgets/LoaderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'HomePage.dart';
import 'LinkFiles/EndPoints.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemscontroller().getMenu();
    itemscontroller().requestPermission();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/welcome.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Container(
            //   padding: EdgeInsets.only(left: 35, top: 130),
            //   child: Text(
            //     'Welcome\nBack',
            //     style: TextStyle(color: Colors.white, fontSize: 33),
            //   ),
            // ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7TZdr0D7P6rLTKwBpvmylXO6rf_4fC_vsh7J5zanmGA&s"),
                              SizedBox(height: 30,),
                              Text ("Login", style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),),
                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.center,
                                child: Text("Welcome !",style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(" Login with your credentials",style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),),
                              ),

                              SizedBox(height: 30,)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40
                            ),
                            child: Column(
                              children: [
                                makeInputemail(label: "Email"),
                                // makeInputemail(label: "Email"),
                                makeInputpassword(label: "Password",obsureText: true),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                padding: EdgeInsets.only(top: 3,left: 3),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: CustomColors().mainThemeColor,
                                  child: TextButton(
                                    onPressed:(){
                                      if(Globle.categories.isNotEmpty)
                                      {
                                        loginApi();
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                            msg: "Currently We are Unavailaible",
                                            toastLength: Toast.LENGTH_LONG,
                                            fontSize: 15,
                                          backgroundColor: CustomColors().secondThemeColor,
                                          textColor: CustomColors().secondThemeTxtColor,
                                        );
                                      }

                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(builder: (context) =>  HomePage()));
                                    },child: Text("Login",style: TextStyle(fontSize: 18,color: Colors.white),), ),
                                ),
                              )
                            // MaterialButton(
                            //
                            //   minWidth: double.infinity,
                            //   height: 60,
                            //   onPressed: (){
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(builder: (context) =>  findlocaton()));
                            //
                            //   },
                            //   color: Colors.indigoAccent[400],
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(40)
                            //   ),
                            //   child: Text("Login",style: TextStyle(
                            //       fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white70
                            //   ),),
                            // ),


                          ),
                          SizedBox(height: 12,),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40
                            ),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Forgot password?")),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text("Don't have an account?"),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  const OTPNumber()));

                                  },
                                  child: Text("Sign up",style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,color: Colors.blue
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> loginApi() async {
    String msg="Loging in...";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return  LoaderDialog(msg);
        }); //
    if(emailController.text.isEmpty){
      String msg="Please enter your email";
      Globle().Errormsg(context,msg);
      // Fluttertoast.showToast(
      //     msg: "Please Enter Your Email ",
      //     toastLength: Toast.LENGTH_LONG,
      //     fontSize: 20,
      //     textColor: Colors.green
      // );
      // Navigator.of(context,
      //     rootNavigator: true)
      //     .pop();
    }else if(passwordController.text.isEmpty){
      String msg="Please enter your password";
      Globle().Errormsg(context,msg);
      // Fluttertoast.showToast(
      //     msg: "Please Enter Your Password",
      //     toastLength: Toast.LENGTH_LONG,
      //     fontSize: 20,
      //     textColor: Colors.green
      // );
      // Navigator.of(context,
      //     rootNavigator: true)
      //     .pop();
    }
    var request = http.Request('POST',
        Uri.parse(EndPoints.apiPath +'Authentications/login?userId='+emailController.text.toString()+'&pass='+passwordController.text.toString()));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Login logic
      Navigator.of(context,
          rootNavigator: true)
          .pop();
      String msg="Login Successfully!";
      Globle().Succesmsg(context,msg);
      var responseString = await response.stream.bytesToString();
      final res= json.decode(responseString);
      // print(res["customerId"]);
      Globle.customerid=res["customerId"];
      // Login logic
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Homepage()));
      setState(() {

      });
    }
    else {
      Navigator.of(context,
          rootNavigator: true)
          .pop();
      String msg="Please check your email address and password";
      Globle().Errormsg(context,msg);
      // Fluttertoast.showToast(
      //     msg: "Please check your email address and password",
      //     toastLength: Toast.LENGTH_LONG,
      //     fontSize: 20,
      //     textColor: Colors.white
      // );
      print(response.reasonPhrase);
    }
  }

  makeInputemail({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style:TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: emailController,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,)

      ],
    );
  }

  makeInputpassword({required String label, required bool obsureText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style:TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(

          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,)

      ],
    );
  }


}*/
