import 'dart:async';
import 'dart:io';
import 'package:animated_icon/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudfare;
import 'package:upgrader/upgrader.dart';
import 'package:yoracustomer/Model/Customer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yoracustomer/CartSytem.dart';
import 'package:yoracustomer/Model/Order.dart';
import 'package:yoracustomer/Model/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yoracustomer/Services/App_Updater.dart';
import 'package:yoracustomer/Services/ReceivedNotificationHandler.dart';
import 'package:yoracustomer/paymentdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Controller/itemscontroller.dart';
import 'GlobleVariables/Globle.dart';
import 'LinkFiles/EndPoints.dart';
import 'Model/Categry.dart';
import 'Model/Item.dart';
import 'Model/Restaurant.dart';
import '../LinkFiles/CustomColors.dart';
import 'Services/SendNotificationMessageApi.dart';
import 'Services/ThisDeviceToken.dart';
import 'bottomdetail.dart';
import 'navidrawer.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudStore;

class Homepage extends StatefulWidget {
  // final Function navigate;

  Homepage();

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;
  String facebookUrl = 'https://www.facebook.com/BusinessOnlinePK.Official?mibextid=ZbWKwL';
  String youtubeurl = 'https://youtube.com/@businessonlinepk4779';
  String instagramurl = 'https://instagram.com/businessonline.pk?igshid=NmE0MzVhZDY=';
  // final String landinglink =  'https://restaurantstaff.pk/home/aboutus';
  String minRequiredVersion = '1.0.0';


  var catid = 0;
  //int count = 0;
  List<Item> iems = [Item(itemId: 1,name: "Loading...", description: "", price: 0, dateAdded: DateTime.now())];
  List<OrderItem>? listoforders = [];
  List<Categry> categories = [];//[Categry(name: "", dateAdded: DateTime.now(),items: [Item(name: "", description: "", price: 0, dateAdded: DateTime.now())])];
  Restaurant restaurant = Restaurant(dateAdded: DateTime.now(), from: DateTime.now(), to: DateTime.now());
  //List<BannerModelS>? bannerList = [];
  Order? createOrderLst;
  Timer? _timer;
  Item user = Item(name: "", dateAdded: DateTime.now(), description: "", price: 0);
  bool isLoaded = false;
  bool menuFound = false;


  @override
  bool get wantKeepAlive => true;

  String? mToken = "";

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    _timer!.cancel();
  }

  @override
  void initState()  {
    super.initState();
    getOrderId();
    getCounts();
    getCategories();
    startTimer();
    NotificationProcessor().requestNotificationPermission();
    NotificationProcessor().foregroundMessage();
    setState(() {
    });
    ///For Forced update
    // inAppUpdateFunction(context);
  }

  getOrderId() async {
    int id = await itemscontroller().GetOrderId(context);
    if(id == 1)
    {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  paymentdetail("",oid: Globle.OrderId)));
    }
  }
  Future<List<Categry>> getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? categoryJsonList = preferences.getStringList('categories');
    if (categoryJsonList != null) {
      categories = categoryJsonList.map((categoryJson) => Categry.fromJson(json.decode(categoryJson))).toList();
      if(categories.isNotEmpty)
      {
        menuFound = true;
        getListOfData(categories[0].items);
        print("Categories Length before giving it to TabController in getCategories Function => ${categories.length}");
        _tabController = TabController(vsync: this, length: categories.length);
        _tabController!.addListener(() {
          if (_tabController!.indexIsChanging) {
            // call the API when a different tab is selected
            getListOfData(categories[0].items);
          }
        });

        ///OnScroll Animation-------------------------------------------------->
          //With this the BuildContext error is Resolved without changing
          //the inde in TabBarView index to Zero.
        void onScroll() {
          if (_tabController?.index.toDouble() == _tabController?.animation?.value) {
            // User stopped dragging and animation finished
            setState(() {
              getListOfData(categories[_tabController!.index].items);
            });
          }
        }

        _tabController?.animation?.addListener(onScroll);
        setState(() {

        });
        await itemscontroller().getMenu();
        ///OnScroll Animation end---------------------------------------------->
      }
      else
      {
        menuFound = false;
        await itemscontroller().getMenu();
        getCategories();
      }
    }
    else
    {
      menuFound = false;
      categories = await itemscontroller().getMenu();
      getCategories();
    }
    itemscontroller().getRestaurant();
    String? res = preferences.getString("restaurant");
    restaurant = Restaurant.fromJson(jsonDecode(res!));
    instagramurl = restaurant.instagram;
    facebookUrl = restaurant.facebook;
    youtubeurl = restaurant.youTube;
    print("rrrrrrr${restaurant.minimumOrder}");
    Globle.minimumOrder = restaurant.minimumOrder;
    return categories;
  }

  void _launchFacebook() async {
    if (await canLaunch(facebookUrl)) {
      await launch(facebookUrl);
    } else {
      Fluttertoast.showToast(
        msg: "Link not available",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 15,
        backgroundColor: CustomColors().secondThemeColor,
        textColor: CustomColors().secondThemeTxtColor,
      );
      throw 'Could not launch $facebookUrl';
    }
  }
  void _launchyoutube() async {
    if (await canLaunch(youtubeurl)) {
      await launch(youtubeurl);
    } else {
      Fluttertoast.showToast(
        msg: "Link not available",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 15,
        backgroundColor: CustomColors().secondThemeColor,
        textColor: CustomColors().secondThemeTxtColor,
      );
      throw 'Could not launch $youtubeurl';
    }
  }
  void _launchinstagram() async {
    if (await canLaunch(instagramurl)) {
      await launch(instagramurl);
    } else {
      Fluttertoast.showToast(
        msg: "Link not available",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 15,
        backgroundColor: CustomColors().secondThemeColor,
        textColor: CustomColors().secondThemeTxtColor,
      );
      throw 'Could not launch $instagramurl';
    }
  }
  void _launchlink(String landingLink) async {
    if (await canLaunch(landingLink)) {
      await launch(landingLink);
    } else {
      throw 'Could not launch $landingLink';
    }
  }


  @override
  Widget build(BuildContext context) {
    //startTimer();
    //print(Globle.OrderId.toString()+"order number");

    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        showLater: false,
        showReleaseNotes: true,
        canDismissDialog: false,
        shouldPopScope: () => false,
        dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
        durationUntilAlertAgain: Duration(seconds: 10),
        minAppVersion: Platform.isAndroid ? minRequiredVersion : minRequiredVersion,
      ),

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors().mainThemeColor,
          ///Test App Test App Bar
          // title: Row(
          //   children: [
          //     ElevatedButton(
          //         onPressed: (){
          //           try {
          //             String operatorToken = "";
          //             int i = 0;
          //             cloudfare.FirebaseFirestore.instance
          //                 .collection("Employees")
          //                 .where("fkRestaurantId", isEqualTo: EndPoints.Resturantid)
          //                 .get()
          //                 .then((cloudfare.QuerySnapshot snapshot) {
          //               snapshot.docs.forEach((doc) {
          //                 if (doc['userType'] == 'x') {
          //                   operatorToken = doc['token'];
          //                   i++;
          //                   print("Operator Token found in Doc $i from Firebase => $operatorToken");
          //                   String notificationBody =
          //                       "New Order Received, Please Check";
          //                   String notificationTitle = "New Order Alert";
          //                   String notificationPayloadType = "New Order";
          //                   String notificationPayloadMessage =
          //                       "New Order Notification message from YORA";
          //                   String receiverChannelId = "restaurantAdmin1";
          //                  SendMessageApi().sendMessage(
          //                      operatorToken,
          //                      notificationBody,
          //                      notificationTitle,
          //                      notificationPayloadType,
          //                      notificationPayloadMessage,
          //                      receiverChannelId,
          //                      EndPoints.Resturantid.toString());
          //
          //                   print("userType == 'x' found in $i doc in collection(Employees) where(fkRestaurantId, isEqualTo: EndPoints.Resturantid)");
          //                 } else if (doc['userType'] == 'o') {
          //                   print("userType == 'x' not found in $i doc in collection(Employees) where(fkRestaurantId, isEqualTo: EndPoints.Resturantid)");
          //                 }
          //               });
          //             });
          //           } catch (e) {print("Error Sending Notification to Owner App => $e");}
          //         },
          //         child: Text("OpOdr")),
          //
          //     // ElevatedButton(onPressed: () {
          //     //   String mineToken = myToken;
          //     //   String notificationBody = "New Order Test Alert";
          //     //   String notificationTitle = "New Order";
          //     //   String notificationPayloadType = 'New Order';
          //     //   String notificationPayloadMessage = 'Test New Order notification payload message';
          //     //   String receiverChannelId = "restaurantAdmin1";
          //     //   SendMessageApi().sendMessage(mineToken, notificationBody, notificationTitle, notificationPayloadType, notificationPayloadMessage, receiverChannelId, "");
          //     // }, child:const Text("Order")),
          //
          //     // ElevatedButton(onPressed: () {
          //     //   String mineToken = myToken;
          //     //   String notificationBody = "Order cancelled by => ";
          //     //   String notificationTitle = "Order Cancelled";
          //     //   String notificationPayloadType = 'Order Cancelled';
          //     //   String notificationPayloadMessage = 'Test New Message notification payload message';
          //     //   String receiverChannelId = "restaurantAdmin3";
          //     //   SendMessageApi().sendMessage(mineToken, notificationBody, notificationTitle, notificationPayloadType, notificationPayloadMessage, receiverChannelId, "");
          //     // }, child:const Text("CNL")),
          //
          //     ElevatedButton(onPressed: () {
          //       String mineToken = myToken;
          //       String notificationBody = "New Message Test alert";
          //       String notificationTitle = "New Message";
          //       String notificationPayloadType = 'New Message';
          //       String notificationPayloadMessage = 'Test Other notification payload message';
          //       String receiverChannelId = "restaurantAdmin2";
          //       SendMessageApi().sendMessage(mineToken, notificationBody, notificationTitle, notificationPayloadType, notificationPayloadMessage, receiverChannelId, "");
          //     }, child:const Text("MSG")),
          //   ],
          // ),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            buildBadge(),
          ],
        ),
        drawer: const navidrawer(),
        body: SafeArea(
          child: menuFound? Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 1/2,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 2.0),
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: Visibility(
                              visible: Globle.bannerDataList.isNotEmpty,
                              replacement: CarouselSlider.builder(
                                itemCount: 1,
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: 150,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  reverse: false,
                                  aspectRatio: 5.0,
                                ),
                                itemBuilder: (context, i, id) {
                                  List<String> imagePaths = ['assets/main.jpg',];
                                  //for onTap to redirect to another screen
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: CustomColors().mainThemeTxtColor,
                                          )),
                                      //ClipRRect for image border radius
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          imagePaths[i],
                                          width: MediaQuery.of(context).size.width *0.9,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              child: CarouselSlider.builder(
                                itemCount: Globle.bannerDataList.length,
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: 150,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  reverse: false,
                                  aspectRatio: 5.0,
                                ),
                                itemBuilder: (context, i, id) {
                                  //for onTap to redirect to another screen
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: CustomColors().itemsListTxtColor,
                                          )),
                                      //ClipRRect for image border radius
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          Globle.bannerimgpath+Globle.bannerDataList[i].webBanner,
                                          width: 500,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      var url =  Globle.bannerDataList[i].webBanner;
                                      var landingLink =  Globle.bannerDataList[i].landingLink;
                                      try{
                                        int id = int.parse(Globle.bannerDataList[i].mobileBanner);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => bottomdetail(itemId: id)));
                                      }catch(e){
                                        _launchlink(landingLink);
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                        ),

                        Container(
                          width: double.infinity,
                          height: 50,
                          color: CustomColors().secondThemeColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                ///Links Launching Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///Launch Facebook Icon
                                    GestureDetector(
                                      onTap: (){
                                        _launchFacebook();
                                        var notificationData = {"oid": "1561","type":"o"};
                                        // itemscontroller().sendPushMessage("fUxpxVj1S3alNRxpqlgaGU:APA91bEEXsp096Wt4HtT6H_DLfCW_XX2qgvrg76SbSIO7X3xdGpfUqeXVamUMrDysCBxC-7Z4-kGQkV7Kyb5UVIIvwbg30fO_BvHc_I0jE1wFOkZlPnFOeeb4-P0jW4_L1vQm9iAN4Ct","Alert", "Testing body",notificationData,);
                                      },
                                      child: Image.asset("assets/facebook.png",height: 40,),
                                    ),
                                    ///Launch Google Maps Icon
                                    GestureDetector(
                                      onTap: (){
                                        _launchyoutube();
                                        //itemscontroller().sendPushMessage("fyRVc8pNR0CuvkJyCSFwPs:APA91bFHsyoiTkzsXVvsXlsd_ChjFNfO9MqtYmweKyoSEfH8kjZSeuW2LYuLCbfizXPZ4Ky-dkVrH6FlDcSBgOIWh9fKnYSRnTum6AofYjwupN8EI7TYY_24PaYxZGnVvJp3jrvUHeRl","Message", "Testing body","");

                                      },
                                      child: Image.asset("assets/map.png",height: 40,),
                                      /*child: FaIcon(
                                        FontAwesomeIcons.locationArrow,
                                        color: restaurant.youTube == " "? Colors.grey : CustomColors().youtube,
                                        size: 40,
                                      ),*/
                                    ),
                                    ///Launch Instagram Icon
                                    GestureDetector(
                                      onTap: (){
                                        _launchinstagram();
                                      },
                                      child: Image.asset("assets/insta.png",height: 40,),
                                      /*child: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: restaurant.instagram == " "? Colors.grey : CustomColors().insta,
                                        size: 40,
                                      ),*/
                                    ),
                                  ],
                                ),

                                // Text(' FREE DELIVERIES, DINE-IN discounts\n & more in just Rs.150/month. Get\n gloriajeansPRO now', style: TextStyle(color: Colors.black , fontSize: 15),),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                restaurant.name,
                                style:
                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )),
                        const SizedBox(
                          height: 0,
                        ),
                        IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('${Globle.showPrice(Globle.homeMinimumOrder.toDouble())} Minimum'),
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delivery_dining,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Delivery: ${Globle.deliveryTime} min'),
                            ],
                          ),
                        ),
                        // TabBar(
                        //   controller: controller,
                        //   isScrollable: true,
                        //   labelColor: Colors.black,
                        //   onTap: (int index) {
                        //     setState(() {
                        //       getListOfData(categories[index].items);
                        //
                        //     });
                        //   },
                        //   // tabs: [
                        //   tabs: categories
                        //       .map((model) => Tab(text: model.name))
                        //       .toList(),
                        // ),
                        // const SizedBox(
                        //   height: 1.0,
                        // ),
                        // Container(
                        //   height: 500,
                        //   child: TabBarView(
                        //     physics: const ScrollPhysics(), // new
                        //     controller: controller,
                        //     // children: <Widget>[
                        //     children: categories.map((item) {
                        //       return Center(
                        //         child: buildListView(),
                        //       );
                        //     }).toList(),
                        //     // buildListView(),
                        //     // buildListView(),
                        //     // buildListView(),
                        //     // buildListView(),
                        //     // ],
                        //   ),
                        // ),

                      ],
                    ),
                  ),
                ),
              ),
              ///TODO: DraggableScrollableSheet
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 1.0,
                builder: (BuildContext context,
                    ScrollController scrollController) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          ///TabBar
                          // width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black, // Shadow color
                            //     offset: Offset(3, 0), // Offset from the top
                            //     blurRadius: 7.0, // Spread of the shadow
                            //   ),
                            // ],
                          ),
                          ///TabBar------------------------------------------>
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black.withOpacity(0.6),
                              // overlayColor: MaterialStateProperty.all(Colors.blue.shade700),
                              // The color of underline
                              indicatorColor: Colors.black,
                              indicatorWeight: 3,
                              // dividerColor: Colors.redAccent,
                              tabs: categories.map((model) => Tab(text: model.name)).toList(),
                            ),
                          ),
                        ),
                        ///TabBarView---------------------------------------->
                        Expanded(
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black, // Shadow color
                                  offset: Offset(0, 2), // Offset from the top
                                  blurRadius: 7.0, // Spread of the shadow
                                ),
                              ],
                            ),
                            child: TabBarView(
                              controller: _tabController,
                              children: categories.map((item) {
                                return iems.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    : Visibility(
                                  visible: isLoaded,
                                  replacement: const Center(child: Image(image: AssetImage(
                                      "assets/loading.gif"
                                  )),),
                                  child: ListView.builder(
                                      itemCount: iems.length,
                                      // physics: const PageScrollPhysics(),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 0,
                                          color: CustomColors().itemsListColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              onTap: () {
                                                setState(() {

                                                });
                                                print("User Selected an item going from Homescreen to Bottom Detail----------------->");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) =>  bottomdetail(itemId:iems[index].itemId)));
                                              },
                                              contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),

                                              title: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                      visible: isLoaded,
                                                      replacement: const Center(child: Image(image: AssetImage(
                                                          "assets/loading.gif"
                                                      )),),
                                                      child: Text(
                                                        // iems![index].name + "${iems!.length}",
                                                        iems[index].name,  // Access the first item in the list (index 0)
                                                        style: TextStyle(
                                                          color: CustomColors().itemsListTxtColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )

                                                  ),
                                                ],
                                              ),
                                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                              subtitle: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  // Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                                  Text(iems[index].description.toString(),
                                                      style: TextStyle(color: CustomColors().itemsListTxtColor)),
                                                  if(iems[index].price > 0)...
                                                  [
                                                    if(iems[index].discount > 0)...[
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            const TextSpan(text: "\n"),
                                                            TextSpan(
                                                              text: Globle.showPrice(iems[index].price),
                                                              style: TextStyle(
                                                                color: CustomColors().itemsListTxtColor,
                                                                fontSize: 13,
                                                                decoration: TextDecoration.lineThrough, // Add a strikethrough
                                                                decorationColor: Colors.red, // Set the color of the strikethrough to red
                                                                decorationThickness: 4.0, // Set the thickness of the strikethrough
                                                              ),
                                                            ),
                                                            const TextSpan(text: "\n"),
                                                            TextSpan(
                                                              text: Globle.showPrice(iems[index].discount),
                                                              style: TextStyle(
                                                                color: CustomColors().itemsListTxtColor,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]else...[
                                                      Text("\n${Globle.showPrice(iems[index].price)}",
                                                        style: TextStyle(
                                                          color: CustomColors().itemsListTxtColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ],
                                                ],
                                              ),
                                              trailing: iems[index].imgUrl == "NotFound.png"? Image.network(Globle.defaultImgPath ,
                                                height: 100,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ): Image.network(Globle.itemImgPath + iems[index].imgUrl,
                                                height: 100,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }).toList(),
                            ),

                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          )
              :Center(
            child:SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image(image: AssetImage(
                        "assets/loading.gif"
                    )),
                  ),
                  Text(
                    "\n\n\n\n\n\n\n\nSorry we are not \navailable at the moment",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getListOfData(List<Item>? items) {
    isLoaded = false;
    try {
      if(items != null && items.isNotEmpty)
      {
        iems = items;
        if(iems.isNotEmpty)
        {
          isLoaded = true;
        }
      }
    } catch (e) {
      // print(e);
    }
    if (mounted) setState(() {});
  }

  // this method is for bottom sheet
  getItemDetails(int? itemID, int index) async {
    try {
      user = await itemscontroller().getUser(itemID);
      // bottomsheetData(
      //     iems![index].itemId, user!.name.toString(), user!.price.toString());
    } catch (e) {
      // print(e);
    }
    setState(() {});
    if (mounted) setState(() {});
  }

  Future<void> getCounts() async {
    if(Globle.customerid > 0){
      try {
        listoforders = await itemscontroller().OrderItems();
        if(listoforders == null) {
          Customer.itemsCount = 0;
        }

        Customer.itemsCount = listoforders!.length;

        if(Customer.itemsCount == 0)
        {
          listoforders = await itemscontroller().OrderItems();
          Customer.itemsCount = listoforders!.length;
        }

      } catch (e) {
        // print(e);
      }
    }
    if (mounted) setState(() {});
  }

  // buildListView() {
  //   return iems.isEmpty
  //       ? const Center(child: Text('Empty'))
  //       : GestureDetector(
  //     onTap: (){
  //
  //     },
  //     child:  Visibility(
  //       visible: isLoaded,
  //       replacement: const Center(child: Image(image: AssetImage(
  //           "assets/loading.gif"
  //       )),),
  //       child: ListView.builder(
  //           itemCount: iems.length,
  //           physics: const PageScrollPhysics(),
  //           itemBuilder: (context, index) {
  //
  //             return Card(
  //               elevation: 0,
  //               color: CustomColors().itemsListColor,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ListTile(
  //                   onTap: () {
  //                     setState(() {
  //
  //                     });
  //
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(builder: (context) =>  bottomdetail(itemId:iems[index].itemId)));
  //                   },
  //                   contentPadding:
  //                   const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
  //
  //                   title: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Visibility(
  //                         visible: isLoaded,
  //                         replacement: const Center(child: Image(image: AssetImage(
  //                             "assets/loading.gif"
  //                         )),),
  //                         child: Text(
  //                           // iems![index].name + "${iems!.length}",
  //                           iems[index].name ,
  //                           style: TextStyle(
  //                               color: CustomColors().itemsListTxtColor,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
  //
  //                   subtitle: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       // Icon(Icons.linear_scale, color: Colors.yellowAccent),
  //                       Text(iems[index].description.toString(),
  //                           style: TextStyle(color: CustomColors().itemsListTxtColor)),
  //                       if(iems[index].price > 0)...
  //                       [
  //                         if(iems[index].discount > 0)...[
  //                           RichText(
  //                             text: TextSpan(
  //                               children: [
  //                                 const TextSpan(text: "\n"),
  //                                 TextSpan(
  //                                   text: Globle.showPrice(iems[index].price),
  //                                   style: TextStyle(
  //                                     color: CustomColors().itemsListTxtColor,
  //                                     fontSize: 13,
  //                                     decoration: TextDecoration.lineThrough, // Add a strikethrough
  //                                     decorationColor: Colors.red, // Set the color of the strikethrough to red
  //                                     decorationThickness: 4.0, // Set the thickness of the strikethrough
  //                                   ),
  //                                 ),
  //                                 const TextSpan(text: "\n"),
  //                                 TextSpan(
  //                                   text: Globle.showPrice(iems[index].discount),
  //                                   style: TextStyle(
  //                                     color: CustomColors().itemsListTxtColor,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ]else...[
  //                           Text("\n${Globle.showPrice(iems[index].price)}",
  //                             style: TextStyle(
  //                               color: CustomColors().itemsListTxtColor,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           )
  //                         ],
  //                       ],
  //                     ],
  //                   ),
  //                   trailing: iems[index].imgUrl == "NotFound.png"? Image.network(Globle.defaultImgPath ,
  //                     height: 100,
  //                     width: 70,
  //                     fit: BoxFit.cover,
  //                   ): Image.network(Globle.itemImgPath + iems[index].imgUrl,
  //                     height: 100,
  //                     width: 70,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }

  buildBadge() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if(menuFound){
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartSytem()));
              setState(() {});
            }
            else{
              Globle().Errormsg(context, "Sorry we are not available at the moment");
            }

          },
          child: MyBadge(
            value: Globle.customerid > 0? Customer.itemsCount.toString():"0",
            //value: count.toString(),
            top: -1,
            right: -1,
            color: Colors.red,
            child: GestureDetector(
              /*onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartSytem()));
                setState(() {});
              },*/
              child: AnimateIcon(
                key: UniqueKey(),
                onTap: () {
                  if(menuFound){
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CartSytem()));
                    setState(() {});
                  }
                  else{
                    Globle().Errormsg(context, "Sorry we are not available at the moment");
                  }
                },
                iconType:Customer.itemsCount > 0? IconType.continueAnimation:IconType.onlyIcon,
                height: 40,
                width: 40,
                color: Colors.white,
                animateIcon: AnimateIcons.paid,
              ),
            ),
          ),
        ),
      ),
    );
  }



  void startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 4), (Timer t) async {
      buildBadge();
      Globle.bannerDataList = await itemscontroller().fetchBanners();
      menuFound = false;
      await itemscontroller().getMenu();
      getCategories();
    });
    setState(() {

    });
  }
}

class MyBadge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child; // our badge widget will wrap this child widget
  final String value; // what displays inside the badge
  final Color color; // the  background color of the badge - default is red

  const MyBadge(
      {Key? key,
        required this.child,
        required this.value,
        this.color = Colors.red,
        required this.top,
        required this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }

}

class BlinkingIcon extends StatefulWidget {
  final IconData icon;

  BlinkingIcon({required this.icon});

  @override
  _BlinkingIconState createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _numBlinks = 0;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.1, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _numBlinks++;
            _isVisible = !_isVisible;
            _controller.reverse();
          });
        }
        if (_numBlinks == 5) {
          _controller.stop();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? _animation.value : 1.0,
      duration: const Duration(milliseconds: 1000),
      child: Icon(widget.icon,size: 35, color: Colors.black,),
    );
  }


}
