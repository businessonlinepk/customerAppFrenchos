import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoracustomer/Model/Banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../HomePage.dart';
import '../LinkFiles/CustomColors.dart';
import '../Model/Categry.dart';
import '../LinkFiles/EndPoints.dart';

class Globle {
  // these variables need to be update when ever we are going to make a copy
  static String Currency = "£";
  static String showPrice(double price) => "$Currency ${price.toStringAsFixed(0)}";
  static String countryCode = "44";
  static String testingNumber = "7578651350";
  static int numCount = 10;
  static String mapValue = "£";
  static String NotificationKey = 'key=AAAAzOiKyPM:APA91bH8Q4SaR8AH1bzxMt-rFqlyOkMg7_5J6GlShXzGRyUy08Eu2nYzVlshKr8Mwa4UohCrzk02EIN96mcqD47dksn_EVGdLIIfs_ZGBD0NXqkxr8lcusGIu3sMDYAzWIvODNZk9aJ2';
  static String defaultImgPath = defaultImg;
  static String itemImgPath = "https://restaurantstaff.pk/images/UK/Restaurants/" + EndPoints.Resturantid.toString() + "/Items/";
  static String logoPath = "https://restaurantstaff.pk/images/UK/Restaurants/"+ EndPoints.Resturantid.toString() +"/";
  static String bannerimgpath = "https://restaurantstaff.pk/images/UK/Restaurants/"+ EndPoints.Resturantid.toString() +"/Banners/" ;
  static String defaultImg = "https://restaurantstaff.pk/images/UK/Restaurants/"+ EndPoints.Resturantid.toString() +"/NotFound.png";
  //
  static String LogoImg = defaultImg;



  void goBackToHome(BuildContext context){
    Timer(const Duration(seconds: 20 ), () async {
      Globle().Infomsg(context, "Sorry for trouble, please try again");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Homepage()));
    });
  }

  static int minimumOrder = 0;
  static int homeMinimumOrder = 0;
  static String uniqueId = "";
  static int deliveryTime = 0;
  static String token = "";
  static String instruction = ".";
  static int customerid = 0;
  static String customerName = "";
  static String customerNumber = "";
  static int OrderId = 0;
  static bool OrderGenerated = false;


  static   int waitingTime = 0;
  static List<Categry> categories = [];
  static List<BannerModelS> bannerDataList = [];
  static bool isLoggedIn = false;
  // static int ResturantIntId = 0;

  ///Showing SnackBar messages
  void Succesmsg(BuildContext context, String msg){
    if(msg == "")
    {
      msg = "";
    }

    OverlayState? o = Overlay.of(context);
    showTopSnackBar(
      o,
      CustomSnackBar.success(
        message: msg,
        backgroundColor: CustomColors().secondThemeColor,
        textStyle: TextStyle(color: CustomColors().secondThemeTxtColor),

      ),
    );
  }
  void Errormsg(BuildContext context, String msg){
    if(msg == "")
    {
      msg = "";
    }

    OverlayState? o = Overlay.of(context);
    showTopSnackBar(
      o,
      CustomSnackBar.error(
        message: msg,
      ),
    );
  }

  void Infomsg(BuildContext context, String msg){
    if(msg == "")
    {
      msg = "";
    }
    OverlayState? o = Overlay.of(context);
    showTopSnackBar(
      o,
      CustomSnackBar.info(
        message: msg,
        backgroundColor: CustomColors().secondThemeColor,
        textStyle: TextStyle(color: CustomColors().secondThemeTxtColor),
      ),
    );
  }

}
final TextStyle pkrStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);