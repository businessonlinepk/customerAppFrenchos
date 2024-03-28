import 'dart:convert';
import 'package:yoracustomer/DeleteAccount.dart';
import 'package:yoracustomer/Model/Restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoracustomer/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LinkFiles/CustomColors.dart';

import 'GlobleVariables/Globle.dart';
import 'Historylist.dart';
import 'HomePage.dart';

class navidrawer extends StatefulWidget {
  const navidrawer({Key? key}) : super(key: key);

  @override
  State<navidrawer> createState() => _navidrawerState();
}

class _navidrawerState extends State<navidrawer> {
  Restaurant restaurant = Restaurant(dateAdded: DateTime.now(), from: DateTime.now(), to: DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRestaurant();
  }
  getRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var res = preferences.getString("restaurant");
    try{
      restaurant = Restaurant.fromJson(jsonDecode(res!));
    }
    catch(e){

    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: CustomColors().mainThemeColor),
            accountName: Text(Globle.customerName),
            accountEmail: Text(Globle.customerNumber),
            currentAccountPicture: CircleAvatar(foregroundImage: NetworkImage(Globle.LogoImg),backgroundColor: CustomColors().mainThemeColor,),
            otherAccountsPictures: const [
              //CircleAvatar(foregroundImage: AssetImage("assets/images/t.jpg")),
              //CircleAvatar(foregroundImage: AssetImage("assets/images/t.jpg")),
            ],

          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Homepage'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return  Homepage();
                  }));
            },
          ),
          if(Globle.customerid > 0)...
            [
              ListTile(
                leading: const Icon(Icons.person_add_alt_sharp),
                title: const Text('Personal Information'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return  profile();
                      }));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.history,
                ),
                title: const Text('History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return  HistoryList();
                      }));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                ),
                title: const Text('Delete Account'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text(
                          "Are you sure you want to delete your account permanently?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return  const DeleteAccount();
                                }));
                          },
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("No"),
                        )
                      ],
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(
                    Icons.privacy_tip
                ),
                title: const Text('Logout'),
                onTap: () async {
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
                },
              ),
            ],
          /*const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text("Version ${restaurant.appVersion}",textAlign: TextAlign.center,),
            subtitle: Text("Last update: ${restaurant.appVersionDate!.day}/${restaurant.appVersionDate!.month}/${restaurant.appVersionDate!.year}",textAlign: TextAlign.center,),
          ),*/
        ],
      ),
    );
  }
}
