
import 'package:yoracustomer/Confirmation.dart';
import 'package:yoracustomer/Controller/VerityGroupsController.dart';
import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/Model/Area.dart';
import 'package:yoracustomer/Model/Customer.dart';
import 'package:yoracustomer/widgets/CsutomTextField.dart';
import 'package:yoracustomer/widgets/CustomButton.dart';
import 'package:yoracustomer/widgets/CustomSizedBox.dart';
import 'package:yoracustomer/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Controller/itemscontroller.dart';
import '../Model/Order.dart';
import 'Controller/BankAccountsController.dart';
import 'Model/BankAccount.dart';
import 'Model/CustomerAddress.dart';
import 'Model/RestaurantArea.dart';
import 'Services/CureentLocationFunction.dart';
import 'package:google_maps_webservice/places.dart';
import '../LinkFiles/CustomColors.dart';

///Original, Not Working
const kGoogleApiKey = "AIzaSyCLFYsLuixpirWLa--cSHA3RPwc9-dGprk";
///First Key, Provided in Chikachino group by Sir Zubair
// const kGoogleApiKey = "AIzaSyBDZxj6_-rDyeWllU18Zu1NNkoAWJZXbXY";
///Four Star Key, Working but needs to be replaced by new Key for YORA of Google-maps.
// const kGoogleApiKey = "AIzaSyCXtR_3yvG68lHSDXgd41McF-scs-Q1h9Q";

class ReviewDetail extends StatefulWidget {
  const ReviewDetail(this.instruction);

  final String instruction;

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  Customer? customerData;
  Order orderDtl = Order(dateAdded: DateTime.now(), dispatchTime: DateTime.now(), deliveryTime: DateTime.now(), customer: Customer(dateAdded: DateTime.now()), preparationTime: DateTime.now());

  String? name = "-", addre = "-", contct = "-", eml = "-";
  String? tax = "0", develivery = "0", subtotal = "0", Total = "0";

  //TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController otherAddressController = TextEditingController();
  final currentLocation = CurrentLocationFunction();

  String instruction = "";
  List<BankAccount>? bnkdetl = [];
  String pickuplocation = "";

  int _selectedRadio = -1;
  bool checkButton = false;
  String? onCash = "";
  int tableId = 0;
  double Tax = 0;
  bool isLoaded = false;
  bool areasLoaded = false;

  List<RestaurantArea> allAreas = [];
  int dropdownValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCustomerDetail(Globle.customerid.toString());
    getdetail(Globle.OrderId.toString());
    getaccountdetail();
    pickCurrentLocation();
  }

  pickCurrentLocation() async {
    Position? position = await currentLocation.getCurrentLocation(context);
    if (position != null) {
      // Get the address based on the latitude and longitude
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark placemark = placemarks[0];
      String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";

      setState(() {
        pickuplocation = address;
        customerData!.latitude = position.latitude;
        customerData!.longitude =position.longitude;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          "Review Details",
          style: TextStyle(color: CustomColors().mainThemeTxtColor),
        ),
        backgroundColor: CustomColors().mainThemeColor,
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: Image(image: AssetImage("assets/loading.gif")),
        ),
        child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const ReusableSizedBox(
                              height: 8,
                              width: 0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: customerData?.contact.toString() ?? "-",
                                  textAlign: TextAlign.start,
                                  alimnt: Alignment.topLeft,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                if(orderDtl.orderType)...[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            //builder: (context) => EditScreen(customerData!.name,customerData!.email,customerData!.address,customerData!.contact),
                                            builder: (context) =>
                                                EditScreen(customerData!,allAreas),
                                          ),
                                        );
                                      },
                                      child: const Text("Add address"),
                                    ),
                                  )
                                ],

                                //child: const Text("Edit",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,backgroundColor: Colors.blue,),)),
                              ],
                            ),
                            /*ReusableText(
                              text: customerData?.contact.toString() ?? "-",
                              textAlign: TextAlign.start,
                              alimnt: Alignment.topLeft,
                            ),*/
                            if(orderDtl.orderType)...[
                              ReusableTextField(
                                hintText: "Enter your Name",
                                controller: nameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text("Current Location",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              InkWell(
                                  onTap: () async {
                                    var place = await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: kGoogleApiKey,
                                        mode: Mode.overlay,
                                        types: [],
                                        strictbounds: false,
                                        components: [Component(Component.country, Globle.mapValue)],
                                        //google_map_webservice package
                                        onError: (err) {
                                          print(err);
                                        });

                                    if (place != null) {
                                      setState(() {
                                        pickuplocation = place.description.toString();
                                      });

                                      //form google_maps_webservice package
                                      final plist = GoogleMapsPlaces(
                                        apiKey: kGoogleApiKey,
                                        //apiHeaders: await const GoogleApiHeaders().getHeaders(),
                                        //from google_api_headers package
                                      );
                                      String placeid = place.placeId ?? "0";
                                      final detail = await plist.getDetailsByPlaceId(placeid);
                                      final geometry = detail.result.geometry!;
                                      customerData!.latitude = geometry.location.lat;
                                      customerData!.longitude = geometry.location.lng;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        width: MediaQuery.of(context).size.width,
                                        //height: 100,
                                        child: ListTile(
                                          title: Text(
                                            pickuplocation,
                                            textAlign: TextAlign.justify,
                                            //overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 18.0),
                                            maxLines: 4,
                                          ),
                                          trailing: const Icon(Icons.search),
                                          dense: true,
                                        )),
                                  )),

                              Visibility(
                                visible: areasLoaded,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(width: 1, color: Colors.black45),
                                    ),
                                    child: Row( // Use a Row to align dropdown and arrow
                                      children: [
                                        Expanded( // Use Expanded to take available width for dropdown
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: DropdownButton<String>(
                                              underline: Container(),
                                              value: dropdownValue.toString(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = int.parse(newValue!);
                                                });
                                              },
                                              items: allAreas.map<DropdownMenuItem<String>>(
                                                    (RestaurantArea item) {
                                                  return DropdownMenuItem<String>(
                                                    value: item.fkAreaId.toString(),
                                                    child: Text(item.areaName),
                                                  );
                                                },
                                              ).toList(),
                                              iconSize: 0,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down), // Fixed dropdown arrow on the right
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /*ReusableTextField(
                                hintText: "Current Address",
                                controller: addressController,
                                validator: (value) {
                                  return null;
                                },
                              ),*/

                              ReusableTextField(
                                hintText: "House no (Optional)",
                                controller: otherAddressController,
                                validator: (value) {
                                  return null;
                                },
                              ),

                            ],
                            const ReusableSizedBox(
                              height: 10,
                              width: 0,
                            ),
                            /*ElevatedButton(onPressed: () async {

                            }, child: const Text("Update"),
                            ),*/
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: "Subtotal",
                                    textAlign: TextAlign.start,
                                    alimnt: Alignment.topLeft,
                                  ),
                                  ReusableText(
                                    text:
                                    Globle.showPrice(double.parse(subtotal!)),
                                    textAlign: TextAlign.start,
                                    alimnt: Alignment.topLeft,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const ReusableSizedBox(
                      height: 10,
                      width: 0,
                    ),

                    /*const ReusableSizedBox(
                      height: 10,
                      width: 0,
                    ),*/

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ReusableText(
                            text: "Choose your payment method",
                            textAlign: TextAlign.start,
                            alimnt: Alignment.topLeft,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          itemCount: bnkdetl!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 90,
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                shadowColor: Colors.blueGrey,
                                // elevation: 10,

                                child: Align(
                                  alignment: Alignment.center,
                                  child: RadioListTile(
                                    value: index,
                                    groupValue: _selectedRadio,
                                    onChanged: (value) {
                                      checkButton = true;
                                      setState(() {
                                        if (bnkdetl![index].bankName.toLowerCase().trim() == "cash") {
                                          _selectedRadio = value!;
                                          onCash = "Cash";
                                          Tax = bnkdetl![index].tax * orderDtl.productsAmount/100;
                                        } else {
                                          _selectedRadio = value!;
                                          tableId = bnkdetl![index].tId;
                                          Tax = bnkdetl![index].tax * orderDtl.productsAmount/100;
                                        }
                                      });
                                    },
                                    title: Text(
                                      bnkdetl![index].bankName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    // subtitle: Text(
                                    //   bnkdetl![index].iban,
                                    // ),
                                    selectedTileColor: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // const SizedBox(
                        //   height: 70,
                        // ),
                      ],
                    ),

                    ///To resolve
                    ///TODO: Confirm Button
                    checkButton == true
                        ? Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: CustomColors().mainThemeColor, width: 2.0)),
                          child: ReusableButton(
                            text: 'Confirmation',
                            onPressed: () async {
                              if(dropdownValue == 0){
                                Globle().Errormsg(context, "Choose an area");
                              }else{
                                customerData!.name = nameController.text;
                                customerData!.address = pickuplocation;
                                customerData!.landmark = otherAddressController.text;
                                customerData!.fkAreaId = dropdownValue;

                                int sc = await itemscontroller()
                                    .UpdateCustomer(customerData!);
                                if (sc == 200) {
                                  if (!orderDtl.orderType) {
                                    customerData!.address = " ";
                                    customerData!.name = " ";
                                  }
                                  if (customerData!.address != '' &&
                                      customerData!.name != "") {
                                    if (onCash == "Cash") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Confirmation(
                                                bid: tableId,
                                                instruction: widget.instruction,
                                                tax: Tax,
                                                onCash: true,
                                              )));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Confirmation(
                                                bid: tableId,
                                                instruction: widget.instruction,
                                                tax: Tax,
                                                onCash: false,
                                              )));
                                    }
                                  } else {
                                    Globle().Infomsg(context,
                                        "Please update your name and address");
                                  }
                                } else {
                                  Globle().Errormsg(context,
                                      "Unable to update, please try again");
                                }
                              }

                            },
                            colors: CustomColors().mainThemeColor,
                            styl: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                        : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: ReusableButton(
                            onPressed: () {},
                            text: "Confirmation",
                            colors: Colors.grey,
                            styl: const TextStyle(

                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),

                          ),
                        ),

                  ],
                ),
              ),
              ///Confirm Button start
              // checkButton == true
              //     ? Positioned(
              //         left: 0,
              //         right: 0,
              //         bottom: 10,
              //           child: Container(
              //             height: 60,
              //             width: MediaQuery.of(context).size.width,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10.0),
              //                 border: Border.all(
              //                     color: CustomColors().mainThemeColor, width: 2.0)),
              //             child: ReusableButton(
              //               text: 'Confirmation',
              //               onPressed: () async {
              //                 if(dropdownValue == 0){
              //                   Globle().Errormsg(context, "Choose an area");
              //                 }else{
              //                   customerData!.name = nameController.text;
              //                   customerData!.address = pickuplocation;
              //                   customerData!.landmark = otherAddressController.text;
              //                   customerData!.fkAreaId = dropdownValue;
              //
              //                   int sc = await itemscontroller()
              //                       .UpdateCustomer(customerData!);
              //                   if (sc == 200) {
              //                     if (!orderDtl.orderType) {
              //                       customerData!.address = " ";
              //                       customerData!.name = " ";
              //                     }
              //                     if (customerData!.address != '' &&
              //                         customerData!.name != "") {
              //                       if (onCash == "Cash") {
              //                         Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                                 builder: (context) => Confirmation(
              //                                   bid: tableId,
              //                                   instruction: widget.instruction,
              //                                   tax: Tax,
              //                                   onCash: true,
              //                                 )));
              //                       } else {
              //                         Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                                 builder: (context) => Confirmation(
              //                                   bid: tableId,
              //                                   instruction: widget.instruction,
              //                                   tax: Tax,
              //                                   onCash: false,
              //                                 )));
              //                       }
              //                     } else {
              //                       Globle().Infomsg(context,
              //                           "Please update your name and address");
              //                     }
              //                   } else {
              //                     Globle().Errormsg(context,
              //                         "Unable to update, please try again");
              //                   }
              //                 }
              //
              //               },
              //               colors: CustomColors().mainThemeColor,
              //               styl: const TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 20),
              //             ),
              //           ),
              //         )
              //     : Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 10,
              //       child: Expanded(
              //         child: SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //           height: 60,
              //           child: ReusableButton(
              //               onPressed: () {},
              //               text: "Confirmation",
              //               colors: Colors.grey,
              //               styl: const TextStyle(
              //
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 20),
              //
              //             ),
              //         ),
              //       ),
              //     ),
            ]),
      ),
    );
  }

  Future<void> getdetail(String orderId) async {
    orderDtl = await itemscontroller().orderDetailsMethod(orderId);
    develivery = orderDtl.deliveryCharges.toString();
    tax = orderDtl.tax.toString();
    subtotal = (orderDtl.productsAmount - orderDtl.discount).toString();
    Total =
        (orderDtl.tax + orderDtl.productsAmount + orderDtl.deliveryCharges)
            .toString();
    // print(orderDtl.deliveryCharges.toString());
    // print(orderDtl.tax.toString());
    // print(orderDtl.productsAmount.toString());

    setState(() {});
  }

  Future<void> getCustomerDetail(String customerid) async {
    customerData = await itemscontroller().GetProfileCustomer();
    //allAreas = await itemscontroller().getRestaurantAreas();
    List<RestaurantArea> areas = await itemscontroller().getRestaurantAreas();
    allAreas = [RestaurantArea(dateAdded: DateTime.now(),areaName: "Choose an Area")];
    if(areas.isNotEmpty) {
      allAreas.addAll(areas);
      areasLoaded = true;
      dropdownValue = customerData!.fkAreaId != 0? customerData!.fkAreaId: allAreas[0].fkAreaId;
    }
    nameController.text = customerData!.name.toString();
    addressController.text = customerData!.address.toString();
    otherAddressController.text = customerData!.landmark.toString();
    // emailController.text = customerData!.email.toString();
    // contactController.text = customerData!.contact.toString();

    setState(() {});
  }

  // Widget MyAlertDialog() {}
  Future<void> getaccountdetail() async {
    try {
      bnkdetl = await BankAccountsController().getBankAccounts();
      if (bnkdetl!.isNotEmpty) {
        isLoaded = true;
      }
    } catch (e) {}
    //setState(() {});
    if (mounted) setState(() {});
  }
}

class EditScreen extends StatefulWidget {
  /*final String name;
  final String email;
  final String address;
  final String contact;*/
  final Customer customer;
  final List<RestaurantArea> allAreas;


  //EditScreen( this.name, this.email,  this.address,  this.contact);
  EditScreen(this.customer, this.allAreas);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController secondaryContactController = TextEditingController();
  final currentLocation = CurrentLocationFunction();
  String pickuplocation = "";
  List<CustomerAddress>? addresses;
  bool isLoaded = false;
  int _addressRadio = -1;
  int dropdownValue = 1;
  @override
  void initState() {
    nameController.text = widget.customer.name;
    emailController.text = widget.customer.email;
    addressController.text = widget.customer.address;
    contactController.text = widget.customer.contact;
    secondaryContactController.text = widget.customer.secondaryContact;
    landmark.text = widget.customer.landmark;
    dropdownValue = widget.customer.fkAreaId != 0? widget.customer.fkAreaId: widget.allAreas[0].fkAreaId;
    super.initState();

    getAddresses();
    pickCurrentLocation();
  }

  void getAddresses() async {
    addresses = await VerityGroupsController().getCustomerAddresses();
    if (addresses != null) {
      setState(() {

        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press event here.
          // Return true if you want to allow the back button press,
          // or false if you want to block the back button press.
          // For example, to block the back button press if a dialog is open:

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReviewDetail("")));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Update Detail"),
            backgroundColor: CustomColors().mainThemeColor,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: ReusableText(
                      text: contactController.text,
                      textAlign: TextAlign.start,
                      alimnt: Alignment.center,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ReusableText(
                    text: "Name",
                    textAlign: TextAlign.start,
                    alimnt: Alignment.topLeft,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "",
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  ReusableText(
                    text: "Other Contact",
                    textAlign: TextAlign.start,
                    alimnt: Alignment.topLeft,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: secondaryContactController,
                      decoration: InputDecoration(
                        hintText: "03**********",
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),

                      keyboardType: TextInputType.number,
                    ),
                  ),
                  ReusableText(
                    text: "Select an area",
                    textAlign: TextAlign.start,
                    alimnt: Alignment.topLeft,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            width: 1, color: Colors.black45),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: dropdownValue.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = int.parse(newValue!);
                              widget.customer.fkAreaId = dropdownValue;
                            });
                          },
                          items: widget.allAreas
                              .map<DropdownMenuItem<String>>(
                                  (RestaurantArea item) {
                                return DropdownMenuItem<String>(
                                  value: item.fkAreaId.toString(),
                                  child: Text(item.areaName),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                  ReusableText(
                    text: "Current Address",
                    textAlign: TextAlign.start,
                    alimnt: Alignment.topLeft,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: kGoogleApiKey,
                            mode: Mode.overlay,
                            types: [],
                            strictbounds: false,
                            components: [Component(Component.country, Globle.mapValue)],
                            //google_map_webservice package
                            onError: (err) {
                              print(err);
                            });

                        if (place != null) {
                          setState(() {
                            pickuplocation = place.description.toString();
                          });

                          //form google_maps_webservice package
                          final plist = GoogleMapsPlaces(
                            apiKey: kGoogleApiKey,
                            //apiHeaders: await const GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );
                          String placeid = place.placeId ?? "0";
                          final detail = await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          widget.customer.latitude = geometry.location.lat;
                          widget.customer.longitude = geometry.location.lng;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            child: ListTile(
                              title: Text(
                                pickuplocation,
                                textAlign: TextAlign.justify,
                                //overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18.0),
                                maxLines: 4,
                              ),
                              trailing: const Icon(Icons.search),
                              dense: true,
                            )),
                      )),
                  ReusableText(
                    text: "House no (Optional)",
                    textAlign: TextAlign.start,
                    alimnt: Alignment.topLeft,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  ReusableTextField(
                    hintText: "",
                    controller: landmark,
                    validator: (value) {
                      return null;
                    },
                  ),

                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              *//*addressController.text =
                                  pickuplocation.toString();*//*
                              widget.customer.contact = contactController.text;
                              widget.customer.name = nameController.text;
                              widget.customer.email = emailController.text;
                              widget.customer.address = addressController.text;
                              widget.customer.landmark = landmark.text;
                              widget.customer.secondaryContact = secondaryContactController.text;

                              await itemscontroller().UpdateCustomer(widget.customer);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReviewDetail("")));
                              setState(() {});
                            },
                            child: const Text("Use Drop off")),
                      ),
                    ],
                  ),
                 */
                  ElevatedButton(
                      onPressed: () async {
                        addressController.text = pickuplocation.toString();
                        widget.customer.contact = contactController.text;
                        widget.customer.name = nameController.text;
                        widget.customer.email = emailController.text;
                        widget.customer.address = pickuplocation;
                        widget.customer.landmark = landmark.text;
                        widget.customer.secondaryContact = secondaryContactController.text;
                        await itemscontroller().UpdateCustomer(widget.customer);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewDetail("")));
                        setState(() {});
                      },
                      child: const Text("Update")),
                  const Divider(),
                  Visibility(
                    visible: isLoaded,
                    replacement: const Center(
                      child: Image(image: AssetImage("assets/loading.gif")),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableText(
                              text: "Other Addresses",
                              textAlign: TextAlign.start,
                              alimnt: Alignment.topLeft,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // add new address page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddAddress(
                                                customer: widget.customer,allAreas: widget.allAreas
                                              ),),);
                                },
                                child: const Text("Add another"),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          itemCount: addresses?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 90,
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                shadowColor: Colors.blueGrey,
                                // elevation: 10,

                                child: Align(
                                  alignment: Alignment.center,
                                  child: RadioListTile(
                                    value: index,
                                    groupValue: _addressRadio,
                                    onChanged: (value) async {
                                      int sc = await VerityGroupsController()
                                          .selectAddress(addresses![index]);
                                      if (sc == 200) {
                                        Globle().Succesmsg(
                                            context, "Address updated");
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ReviewDetail("")));
                                        setState(() {});
                                      }
                                      else{
                                        Globle().Succesmsg(
                                            context, "Error, please try again");
                                      }
                                      setState(() {
                                        if (index == 0) {
                                          _addressRadio = value!;
                                          // bnkdetl![index].tId==0
                                        } else {
                                          _addressRadio = value!;
                                        }
                                      });
                                    },
                                    title: Text(
                                      addresses![index].address.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    selectedTileColor: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  pickCurrentLocation() async {
    Position? position = await currentLocation.getCurrentLocation(context);
    if (position != null) {
      // Get the address based on the latitude and longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark placemark = placemarks[0];
      String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";

      setState(() {
        pickuplocation = address;
        print(address);
         widget.customer.latitude = position.latitude;
         widget.customer.longitude =position.longitude;
      });
    }
  }
}

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key, required this.customer, required this.allAreas}) : super(key: key);

  final Customer customer;
  final List<RestaurantArea> allAreas;

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  //TextEditingController addressControlle = TextEditingController();
  TextEditingController landmark = TextEditingController();
  final currentLocation = CurrentLocationFunction();
  String pickuplocation = "";
  int dropdownValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickCurrentLocation();
    dropdownValue = widget.allAreas[0].fkAreaId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
        backgroundColor: CustomColors().mainThemeColor,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      width: 1, color: Colors.black45),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: dropdownValue.toString(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = int.parse(newValue!);
                      });
                    },
                    items: widget.allAreas
                        .map<DropdownMenuItem<String>>(
                            (RestaurantArea item) {
                          return DropdownMenuItem<String>(
                            value: item.fkAreaId.toString(),
                            child: Text(item.areaName),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            ReusableText(
              text: "Current Address",
              textAlign: TextAlign.start,
              alimnt: Alignment.topLeft,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            InkWell(
                onTap: () async {
                  var place = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: kGoogleApiKey,
                      mode: Mode.overlay,
                      types: [],
                      strictbounds: false,
                      components: [Component(Component.country, Globle.mapValue)],
                      //google_map_webservice package
                      onError: (err) {
                        print(err);
                      });

                  if (place != null) {
                    setState(() {
                      pickuplocation = place.description.toString();
                    });

                    //form google_maps_webservice package
                    final plist = GoogleMapsPlaces(
                      apiKey: kGoogleApiKey,
                      //apiHeaders: await const GoogleApiHeaders().getHeaders(),
                      //from google_api_headers package
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    widget.customer.latitude = geometry.location.lat;
                    widget.customer.longitude = geometry.location.lng;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      //height: 100,
                      child: ListTile(
                        title: Text(
                          pickuplocation,
                          textAlign: TextAlign.justify,
                          //overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18.0),
                          maxLines: 4,
                        ),
                        trailing: const Icon(Icons.search),
                        dense: true,
                      )),
                )),
            /*Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    landmark.text = pickuplocation;
                  },
                  child: const Text("Use Current address")),
            ),*/
            ReusableText(
              text: "House no (optional)",
              textAlign: TextAlign.start,
              alimnt: Alignment.topLeft,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            ReusableTextField(
              hintText: "e.g House no 1, street no 34",
              controller: landmark,
              validator: (value) {
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: CustomColors().mainThemeColor, width: 2.0)),
                child: ReusableButton(
                  text: 'Add',
                  onPressed: () async {

                    CustomerAddress customerAddress = CustomerAddress();
                    customerAddress.address = pickuplocation;
                    customerAddress.landMark = landmark.text;
                    customerAddress.fkAreaId = dropdownValue;
                    customerAddress.fkCustomerId = widget.customer.customerId;
                    customerAddress.longitude = widget.customer.longitude;
                    customerAddress.latitude = widget.customer.latitude;

                    int sc = await itemscontroller()
                        .addNewAddress(customerAddress);

                    if (sc == 200) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditScreen(widget.customer,widget.allAreas)));
                      setState(() {});
                    } else {
                      Globle().Errormsg(context, "Error, Please try again");
                    }
                  },
                  colors: CustomColors().mainThemeColor,
                  styl: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickCurrentLocation() async {
    Position? position = await currentLocation.getCurrentLocation(context);
    if (position != null) {
      // Get the address based on the latitude and longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark placemark = placemarks[0];
      String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";

      setState(() {
        pickuplocation = address;
        widget.customer.latitude = position.latitude;
        widget.customer.longitude =position.longitude;
      });
    }
  }
}

///Backup before Spacing resolved

// import 'package:yoracustomer/Confirmation.dart';
// import 'package:yoracustomer/Controller/VerityGroupsController.dart';
// import 'package:yoracustomer/GlobleVariables/Globle.dart';
// import 'package:yoracustomer/Model/Area.dart';
// import 'package:yoracustomer/Model/Customer.dart';
// import 'package:yoracustomer/widgets/CsutomTextField.dart';
// import 'package:yoracustomer/widgets/CustomButton.dart';
// import 'package:yoracustomer/widgets/CustomSizedBox.dart';
// import 'package:yoracustomer/widgets/CustomText.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import '../Controller/itemscontroller.dart';
// import '../Model/Order.dart';
// import 'Controller/BankAccountsController.dart';
// import 'Model/BankAccount.dart';
// import 'Model/CustomerAddress.dart';
// import 'Model/RestaurantArea.dart';
// import 'Services/CureentLocationFunction.dart';
// import 'package:google_maps_webservice/places.dart';
// import '../LinkFiles/CustomColors.dart';
//
// ///Original, Not Working
// const kGoogleApiKey = "AIzaSyCLFYsLuixpirWLa--cSHA3RPwc9-dGprk";
// ///First Key, Provided in Chikachino group by Sir Zubair
// // const kGoogleApiKey = "AIzaSyBDZxj6_-rDyeWllU18Zu1NNkoAWJZXbXY";
// ///Four Star Key, Working but needs to be replaced by new Key for YORA of Google-maps.
// // const kGoogleApiKey = "AIzaSyCXtR_3yvG68lHSDXgd41McF-scs-Q1h9Q";
//
// class ReviewDetail extends StatefulWidget {
//   const ReviewDetail(this.instruction);
//
//   final String instruction;
//
//   @override
//   State<ReviewDetail> createState() => _ReviewDetailState();
// }
//
// class _ReviewDetailState extends State<ReviewDetail> {
//   Customer? customerData;
//   Order orderDtl = Order(dateAdded: DateTime.now(), dispatchTime: DateTime.now(), deliveryTime: DateTime.now(), customer: Customer(dateAdded: DateTime.now()), preparationTime: DateTime.now());
//
//   String? name = "-", addre = "-", contct = "-", eml = "-";
//   String? tax = "0", develivery = "0", subtotal = "0", Total = "0";
//
//   //TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController otherAddressController = TextEditingController();
//   final currentLocation = CurrentLocationFunction();
//
//   String instruction = "";
//   List<BankAccount>? bnkdetl = [];
//   String pickuplocation = "";
//
//   int _selectedRadio = -1;
//   bool checkButton = false;
//   String? onCash = "";
//   int tableId = 0;
//   double Tax = 0;
//   bool isLoaded = false;
//   bool areasLoaded = false;
//
//   List<RestaurantArea> allAreas = [];
//   int dropdownValue = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     getCustomerDetail(Globle.customerid.toString());
//     getdetail(Globle.OrderId.toString());
//     getaccountdetail();
//     pickCurrentLocation();
//   }
//
//   pickCurrentLocation() async {
//     Position? position = await currentLocation.getCurrentLocation(context);
//     if (position != null) {
//       // Get the address based on the latitude and longitude
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       Placemark placemark = placemarks[0];
//       String address =
//           "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
//
//       setState(() {
//         pickuplocation = address;
//         customerData!.latitude = position.latitude;
//         customerData!.longitude =position.longitude;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors().mainThemeColor.withOpacity(1),
//       appBar: AppBar(
//         title: Text(
//           "Review Details",
//           style: TextStyle(color: CustomColors().mainThemeTxtColor),
//         ),
//         backgroundColor: CustomColors().mainThemeColor,
//       ),
//       body: Visibility(
//         visible: isLoaded,
//         replacement: const Center(
//           child: Image(image: AssetImage("assets/loading.gif")),
//         ),
//         child: Stack(
//             fit: StackFit.loose,
//             clipBehavior: Clip.none,
//             alignment: AlignmentDirectional.bottomCenter,
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Card(
//                       elevation: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//
//                           children: [
//                             const ReusableSizedBox(
//                               height: 8,
//                               width: 0,
//                             ),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ReusableText(
//                                   text: customerData?.contact.toString() ?? "-",
//                                   textAlign: TextAlign.start,
//                                   alimnt: Alignment.topLeft,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 if(orderDtl.orderType)...[
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8.0),
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             //builder: (context) => EditScreen(customerData!.name,customerData!.email,customerData!.address,customerData!.contact),
//                                             builder: (context) =>
//                                                 EditScreen(customerData!,allAreas),
//                                           ),
//                                         );
//                                       },
//                                       child: const Text("Add address"),
//                                     ),
//                                   )
//                                 ],
//
//                                 //child: const Text("Edit",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,backgroundColor: Colors.blue,),)),
//                               ],
//                             ),
//                             /*ReusableText(
//                               text: customerData?.contact.toString() ?? "-",
//                               textAlign: TextAlign.start,
//                               alimnt: Alignment.topLeft,
//                             ),*/
//                             if(orderDtl.orderType)...[
//                               ReusableTextField(
//                                 hintText: "Enter your Name",
//                                 controller: nameController,
//                                 validator: (value) {
//                                   if (value!.isEmpty) {
//                                     return 'Name is required';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(left: 8.0),
//                                 child: Text("Current Location",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
//                               ),
//                               InkWell(
//                                   onTap: () async {
//                                     var place = await PlacesAutocomplete.show(
//                                         context: context,
//                                         apiKey: kGoogleApiKey,
//                                         mode: Mode.overlay,
//                                         types: [],
//                                         strictbounds: false,
//                                         components: [Component(Component.country, Globle.mapValue)],
//                                         //google_map_webservice package
//                                         onError: (err) {
//                                           print(err);
//                                         });
//
//                                     if (place != null) {
//                                       setState(() {
//                                         pickuplocation = place.description.toString();
//                                       });
//
//                                       //form google_maps_webservice package
//                                       final plist = GoogleMapsPlaces(
//                                         apiKey: kGoogleApiKey,
//                                         //apiHeaders: await const GoogleApiHeaders().getHeaders(),
//                                         //from google_api_headers package
//                                       );
//                                       String placeid = place.placeId ?? "0";
//                                       final detail = await plist.getDetailsByPlaceId(placeid);
//                                       final geometry = detail.result.geometry!;
//                                       customerData!.latitude = geometry.location.lat;
//                                       customerData!.longitude = geometry.location.lng;
//                                     }
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8),
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             color: Colors.grey,
//                                             width: 1.0,
//                                           ),
//                                         ),
//                                         padding: const EdgeInsets.all(0),
//                                         width: MediaQuery.of(context).size.width,
//                                         //height: 100,
//                                         child: ListTile(
//                                           title: Text(
//                                             pickuplocation,
//                                             textAlign: TextAlign.justify,
//                                             //overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(fontSize: 18.0),
//                                             maxLines: 4,
//                                           ),
//                                           trailing: const Icon(Icons.search),
//                                           dense: true,
//                                         )),
//                                   )),
//
//                               Visibility(
//                                 visible: areasLoaded,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     height: 50,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       border: Border.all(width: 1, color: Colors.black45),
//                                     ),
//                                     child: Row( // Use a Row to align dropdown and arrow
//                                       children: [
//                                         Expanded( // Use Expanded to take available width for dropdown
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(15.0),
//                                             child: DropdownButton<String>(
//                                               underline: Container(),
//                                               value: dropdownValue.toString(),
//                                               onChanged: (String? newValue) {
//                                                 setState(() {
//                                                   dropdownValue = int.parse(newValue!);
//                                                 });
//                                               },
//                                               items: allAreas.map<DropdownMenuItem<String>>(
//                                                     (RestaurantArea item) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: item.fkAreaId.toString(),
//                                                     child: Text(item.areaName),
//                                                   );
//                                                 },
//                                               ).toList(),
//                                               iconSize: 0,
//                                             ),
//                                           ),
//                                         ),
//                                         const Icon(Icons.arrow_drop_down), // Fixed dropdown arrow on the right
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                               /*ReusableTextField(
//                                 hintText: "Current Address",
//                                 controller: addressController,
//                                 validator: (value) {
//                                   return null;
//                                 },
//                               ),*/
//
//                               ReusableTextField(
//                                 hintText: "House no (Optional)",
//                                 controller: otherAddressController,
//                                 validator: (value) {
//                                   return null;
//                                 },
//                               ),
//
//                             ],
//                             const ReusableSizedBox(
//                               height: 10,
//                               width: 0,
//                             ),
//                             /*ElevatedButton(onPressed: () async {
//
//                             }, child: const Text("Update"),
//                             ),*/
//                             Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ReusableText(
//                                     text: "Subtotal",
//                                     textAlign: TextAlign.start,
//                                     alimnt: Alignment.topLeft,
//                                   ),
//                                   ReusableText(
//                                     text:
//                                     Globle.showPrice(double.parse(subtotal!)),
//                                     textAlign: TextAlign.start,
//                                     alimnt: Alignment.topLeft,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const ReusableSizedBox(
//                       height: 10,
//                       width: 0,
//                     ),
//
//                     /*const ReusableSizedBox(
//                       height: 10,
//                       width: 0,
//                     ),*/
//
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: ReusableText(
//                             text: "Choose your payment method",
//                             textAlign: TextAlign.start,
//                             alimnt: Alignment.topLeft,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         ListView.builder(
//                           itemCount: bnkdetl!.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return SizedBox(
//                               height: 90,
//                               child: Card(
//                                 margin: const EdgeInsets.all(10),
//                                 color: Colors.white,
//                                 shadowColor: Colors.blueGrey,
//                                 // elevation: 10,
//
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: RadioListTile(
//                                     value: index,
//                                     groupValue: _selectedRadio,
//                                     onChanged: (value) {
//                                       checkButton = true;
//                                       setState(() {
//                                         if (bnkdetl![index].bankName.toLowerCase().trim() == "cash") {
//                                           _selectedRadio = value!;
//                                           onCash = "Cash";
//                                           Tax = bnkdetl![index].tax * orderDtl.productsAmount/100;
//                                         } else {
//                                           _selectedRadio = value!;
//                                           tableId = bnkdetl![index].tId;
//                                           Tax = bnkdetl![index].tax * orderDtl.productsAmount/100;
//                                         }
//                                       });
//                                     },
//                                     title: Text(
//                                       bnkdetl![index].bankName,
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                     // subtitle: Text(
//                                     //   bnkdetl![index].iban,
//                                     // ),
//                                     selectedTileColor: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 70,
//                         ),
//                       ],
//                     ),
//
//                   ],
//                 ),
//               ),
//               checkButton == true
//                   ? Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 10,
//                 child: Container(
//                   height: 60,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       border: Border.all(
//                           color: CustomColors().mainThemeColor, width: 2.0)),
//                   child: ReusableButton(
//                     text: 'Confirmation',
//                     onPressed: () async {
//                       if(dropdownValue == 0){
//                         Globle().Errormsg(context, "Choose an area");
//                       }else{
//                         customerData!.name = nameController.text;
//                         customerData!.address = pickuplocation;
//                         customerData!.landmark = otherAddressController.text;
//                         customerData!.fkAreaId = dropdownValue;
//
//                         int sc = await itemscontroller()
//                             .UpdateCustomer(customerData!);
//                         if (sc == 200) {
//                           if (!orderDtl.orderType) {
//                             customerData!.address = " ";
//                             customerData!.name = " ";
//                           }
//                           if (customerData!.address != '' &&
//                               customerData!.name != "") {
//                             if (onCash == "Cash") {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Confirmation(
//                                         bid: tableId,
//                                         instruction: widget.instruction,
//                                         tax: Tax,
//                                         onCash: true,
//                                       )));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Confirmation(
//                                         bid: tableId,
//                                         instruction: widget.instruction,
//                                         tax: Tax,
//                                         onCash: false,
//                                       )));
//                             }
//                           } else {
//                             Globle().Infomsg(context,
//                                 "Please update your name and address");
//                           }
//                         } else {
//                           Globle().Errormsg(context,
//                               "Unable to update, please try again");
//                         }
//                       }
//
//                     },
//                     colors: CustomColors().mainThemeColor,
//                     styl: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//               )
//                   : Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 10,
//                 child: Expanded(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: ReusableButton(
//                       onPressed: () {},
//                       text: "Confirmation",
//                       colors: Colors.grey,
//                       styl: const TextStyle(
//
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//
//                     ),
//                   ),
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
//
//   Future<void> getdetail(String orderId) async {
//     orderDtl = await itemscontroller().orderDetailsMethod(orderId);
//     develivery = orderDtl.deliveryCharges.toString();
//     tax = orderDtl.tax.toString();
//     subtotal = (orderDtl.productsAmount - orderDtl.discount).toString();
//     Total =
//         (orderDtl.tax + orderDtl.productsAmount + orderDtl.deliveryCharges)
//             .toString();
//     // print(orderDtl.deliveryCharges.toString());
//     // print(orderDtl.tax.toString());
//     // print(orderDtl.productsAmount.toString());
//
//     setState(() {});
//   }
//
//   Future<void> getCustomerDetail(String customerid) async {
//     customerData = await itemscontroller().GetProfileCustomer();
//     //allAreas = await itemscontroller().getRestaurantAreas();
//     List<RestaurantArea> areas = await itemscontroller().getRestaurantAreas();
//     allAreas = [RestaurantArea(dateAdded: DateTime.now(),areaName: "Choose an Area")];
//     if(areas.isNotEmpty) {
//       allAreas.addAll(areas);
//       areasLoaded = true;
//       dropdownValue = customerData!.fkAreaId != 0? customerData!.fkAreaId: allAreas[0].fkAreaId;
//     }
//     nameController.text = customerData!.name.toString();
//     addressController.text = customerData!.address.toString();
//     otherAddressController.text = customerData!.landmark.toString();
//     // emailController.text = customerData!.email.toString();
//     // contactController.text = customerData!.contact.toString();
//
//     setState(() {});
//   }
//
//   // Widget MyAlertDialog() {}
//   Future<void> getaccountdetail() async {
//     try {
//       bnkdetl = await BankAccountsController().getBankAccounts();
//       if (bnkdetl!.isNotEmpty) {
//         isLoaded = true;
//       }
//     } catch (e) {}
//     //setState(() {});
//     if (mounted) setState(() {});
//   }
// }
//
// class EditScreen extends StatefulWidget {
//   /*final String name;
//   final String email;
//   final String address;
//   final String contact;*/
//   final Customer customer;
//   final List<RestaurantArea> allAreas;
//
//
//   //EditScreen( this.name, this.email,  this.address,  this.contact);
//   EditScreen(this.customer, this.allAreas);
//
//   @override
//   _EditScreenState createState() => _EditScreenState();
// }
//
// class _EditScreenState extends State<EditScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController landmark = TextEditingController();
//   TextEditingController secondaryContactController = TextEditingController();
//   final currentLocation = CurrentLocationFunction();
//   String pickuplocation = "";
//   List<CustomerAddress>? addresses;
//   bool isLoaded = false;
//   int _addressRadio = -1;
//   int dropdownValue = 1;
//   @override
//   void initState() {
//     nameController.text = widget.customer.name;
//     emailController.text = widget.customer.email;
//     addressController.text = widget.customer.address;
//     contactController.text = widget.customer.contact;
//     secondaryContactController.text = widget.customer.secondaryContact;
//     landmark.text = widget.customer.landmark;
//     dropdownValue = widget.customer.fkAreaId != 0? widget.customer.fkAreaId: widget.allAreas[0].fkAreaId;
//     super.initState();
//
//     getAddresses();
//     pickCurrentLocation();
//   }
//
//   void getAddresses() async {
//     addresses = await VerityGroupsController().getCustomerAddresses();
//     if (addresses != null) {
//       setState(() {
//
//         isLoaded = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           // Handle the back button press event here.
//           // Return true if you want to allow the back button press,
//           // or false if you want to block the back button press.
//           // For example, to block the back button press if a dialog is open:
//
//           Navigator.pop(context);
//           Navigator.pop(context);
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const ReviewDetail("")));
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text("Update Detail"),
//             backgroundColor: CustomColors().mainThemeColor,
//           ),
//           body: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                     child: ReusableText(
//                       text: contactController.text,
//                       textAlign: TextAlign.start,
//                       alimnt: Alignment.center,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   ReusableText(
//                     text: "Name",
//                     textAlign: TextAlign.start,
//                     alimnt: Alignment.topLeft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         hintText: "",
//                         contentPadding: const EdgeInsets.all(15.0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ReusableText(
//                     text: "Other Contact",
//                     textAlign: TextAlign.start,
//                     alimnt: Alignment.topLeft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: secondaryContactController,
//                       decoration: InputDecoration(
//                         hintText: "03**********",
//                         contentPadding: const EdgeInsets.all(15.0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                       ),
//
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   ReusableText(
//                     text: "Select an area",
//                     textAlign: TextAlign.start,
//                     alimnt: Alignment.topLeft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 50,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5.0),
//                         border: Border.all(
//                             width: 1, color: Colors.black45),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: DropdownButton<String>(
//                           underline: Container(),
//                           value: dropdownValue.toString(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               dropdownValue = int.parse(newValue!);
//                               widget.customer.fkAreaId = dropdownValue;
//                             });
//                           },
//                           items: widget.allAreas
//                               .map<DropdownMenuItem<String>>(
//                                   (RestaurantArea item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item.fkAreaId.toString(),
//                                   child: Text(item.areaName),
//                                 );
//                               }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ReusableText(
//                     text: "Current Address",
//                     textAlign: TextAlign.start,
//                     alimnt: Alignment.topLeft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   InkWell(
//                       onTap: () async {
//                         var place = await PlacesAutocomplete.show(
//                             context: context,
//                             apiKey: kGoogleApiKey,
//                             mode: Mode.overlay,
//                             types: [],
//                             strictbounds: false,
//                             components: [Component(Component.country, Globle.mapValue)],
//                             //google_map_webservice package
//                             onError: (err) {
//                               print(err);
//                             });
//
//                         if (place != null) {
//                           setState(() {
//                             pickuplocation = place.description.toString();
//                           });
//
//                           //form google_maps_webservice package
//                           final plist = GoogleMapsPlaces(
//                             apiKey: kGoogleApiKey,
//                             //apiHeaders: await const GoogleApiHeaders().getHeaders(),
//                             //from google_api_headers package
//                           );
//                           String placeid = place.placeId ?? "0";
//                           final detail = await plist.getDetailsByPlaceId(placeid);
//                           final geometry = detail.result.geometry!;
//                           widget.customer.latitude = geometry.location.lat;
//                           widget.customer.longitude = geometry.location.lng;
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey,
//                                 width: 1.0,
//                               ),
//                             ),
//                             padding: const EdgeInsets.all(0),
//                             width: MediaQuery.of(context).size.width,
//                             //height: 100,
//                             child: ListTile(
//                               title: Text(
//                                 pickuplocation,
//                                 textAlign: TextAlign.justify,
//                                 //overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontSize: 18.0),
//                                 maxLines: 4,
//                               ),
//                               trailing: const Icon(Icons.search),
//                               dense: true,
//                             )),
//                       )),
//                   ReusableText(
//                     text: "House no (Optional)",
//                     textAlign: TextAlign.start,
//                     alimnt: Alignment.topLeft,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//
//                   ReusableTextField(
//                     hintText: "",
//                     controller: landmark,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),
//
//                   /* Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               *//*addressController.text =
//                                   pickuplocation.toString();*//*
//                               widget.customer.contact = contactController.text;
//                               widget.customer.name = nameController.text;
//                               widget.customer.email = emailController.text;
//                               widget.customer.address = addressController.text;
//                               widget.customer.landmark = landmark.text;
//                               widget.customer.secondaryContact = secondaryContactController.text;
//
//                               await itemscontroller().UpdateCustomer(widget.customer);
//
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => ReviewDetail("")));
//                               setState(() {});
//                             },
//                             child: const Text("Use Drop off")),
//                       ),
//                     ],
//                   ),
//                  */
//                   ElevatedButton(
//                       onPressed: () async {
//                         addressController.text = pickuplocation.toString();
//                         widget.customer.contact = contactController.text;
//                         widget.customer.name = nameController.text;
//                         widget.customer.email = emailController.text;
//                         widget.customer.address = pickuplocation;
//                         widget.customer.landmark = landmark.text;
//                         widget.customer.secondaryContact = secondaryContactController.text;
//                         await itemscontroller().UpdateCustomer(widget.customer);
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ReviewDetail("")));
//                         setState(() {});
//                       },
//                       child: const Text("Update")),
//                   const Divider(),
//                   Visibility(
//                     visible: isLoaded,
//                     replacement: const Center(
//                       child: Image(image: AssetImage("assets/loading.gif")),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ReusableText(
//                               text: "Other Addresses",
//                               textAlign: TextAlign.start,
//                               alimnt: Alignment.topLeft,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // add new address page
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => AddAddress(
//                                           customer: widget.customer,allAreas: widget.allAreas
//                                       ),),);
//                                 },
//                                 child: const Text("Add another"),
//                               ),
//                             ),
//                           ],
//                         ),
//                         ListView.builder(
//                           itemCount: addresses?.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return SizedBox(
//                               height: 90,
//                               child: Card(
//                                 margin: const EdgeInsets.all(10),
//                                 color: Colors.white,
//                                 shadowColor: Colors.blueGrey,
//                                 // elevation: 10,
//
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: RadioListTile(
//                                     value: index,
//                                     groupValue: _addressRadio,
//                                     onChanged: (value) async {
//                                       int sc = await VerityGroupsController()
//                                           .selectAddress(addresses![index]);
//                                       if (sc == 200) {
//                                         Globle().Succesmsg(
//                                             context, "Address updated");
//                                         Navigator.pop(context);
//                                         Navigator.pop(context);
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => ReviewDetail("")));
//                                         setState(() {});
//                                       }
//                                       else{
//                                         Globle().Succesmsg(
//                                             context, "Error, please try again");
//                                       }
//                                       setState(() {
//                                         if (index == 0) {
//                                           _addressRadio = value!;
//                                           // bnkdetl![index].tId==0
//                                         } else {
//                                           _addressRadio = value!;
//                                         }
//                                       });
//                                     },
//                                     title: Text(
//                                       addresses![index].address.toString(),
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                     selectedTileColor: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
//
//   pickCurrentLocation() async {
//     Position? position = await currentLocation.getCurrentLocation(context);
//     if (position != null) {
//       // Get the address based on the latitude and longitude
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       Placemark placemark = placemarks[0];
//       String address =
//           "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
//
//       setState(() {
//         pickuplocation = address;
//         print(address);
//         widget.customer.latitude = position.latitude;
//         widget.customer.longitude =position.longitude;
//       });
//     }
//   }
// }
//
// class AddAddress extends StatefulWidget {
//   const AddAddress({Key? key, required this.customer, required this.allAreas}) : super(key: key);
//
//   final Customer customer;
//   final List<RestaurantArea> allAreas;
//
//   @override
//   State<AddAddress> createState() => _AddAddressState();
// }
//
// class _AddAddressState extends State<AddAddress> {
//   //TextEditingController addressControlle = TextEditingController();
//   TextEditingController landmark = TextEditingController();
//   final currentLocation = CurrentLocationFunction();
//   String pickuplocation = "";
//   int dropdownValue = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     pickCurrentLocation();
//     dropdownValue = widget.allAreas[0].fkAreaId;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Address"),
//         backgroundColor: CustomColors().mainThemeColor,
//       ),
//       body: Center(
//         child: ListView(
//           children: <Widget>[
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.0),
//                   border: Border.all(
//                       width: 1, color: Colors.black45),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: DropdownButton<String>(
//                     underline: Container(),
//                     value: dropdownValue.toString(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         dropdownValue = int.parse(newValue!);
//                       });
//                     },
//                     items: widget.allAreas
//                         .map<DropdownMenuItem<String>>(
//                             (RestaurantArea item) {
//                           return DropdownMenuItem<String>(
//                             value: item.fkAreaId.toString(),
//                             child: Text(item.areaName),
//                           );
//                         }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//             ReusableText(
//               text: "Current Address",
//               textAlign: TextAlign.start,
//               alimnt: Alignment.topLeft,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             InkWell(
//                 onTap: () async {
//                   var place = await PlacesAutocomplete.show(
//                       context: context,
//                       apiKey: kGoogleApiKey,
//                       mode: Mode.overlay,
//                       types: [],
//                       strictbounds: false,
//                       components: [Component(Component.country, Globle.mapValue)],
//                       //google_map_webservice package
//                       onError: (err) {
//                         print(err);
//                       });
//
//                   if (place != null) {
//                     setState(() {
//                       pickuplocation = place.description.toString();
//                     });
//
//                     //form google_maps_webservice package
//                     final plist = GoogleMapsPlaces(
//                       apiKey: kGoogleApiKey,
//                       //apiHeaders: await const GoogleApiHeaders().getHeaders(),
//                       //from google_api_headers package
//                     );
//                     String placeid = place.placeId ?? "0";
//                     final detail = await plist.getDetailsByPlaceId(placeid);
//                     final geometry = detail.result.geometry!;
//                     widget.customer.latitude = geometry.location.lat;
//                     widget.customer.longitude = geometry.location.lng;
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.grey,
//                           width: 1.0,
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(0),
//                       width: MediaQuery.of(context).size.width,
//                       //height: 100,
//                       child: ListTile(
//                         title: Text(
//                           pickuplocation,
//                           textAlign: TextAlign.justify,
//                           //overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontSize: 18.0),
//                           maxLines: 4,
//                         ),
//                         trailing: const Icon(Icons.search),
//                         dense: true,
//                       )),
//                 )),
//             /*Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: ElevatedButton(
//                   onPressed: () {
//                     landmark.text = pickuplocation;
//                   },
//                   child: const Text("Use Current address")),
//             ),*/
//             ReusableText(
//               text: "House no (optional)",
//               textAlign: TextAlign.start,
//               alimnt: Alignment.topLeft,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             ReusableTextField(
//               hintText: "e.g House no 1, street no 34",
//               controller: landmark,
//               validator: (value) {
//                 return null;
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     border: Border.all(color: CustomColors().mainThemeColor, width: 2.0)),
//                 child: ReusableButton(
//                   text: 'Add',
//                   onPressed: () async {
//
//                     CustomerAddress customerAddress = CustomerAddress();
//                     customerAddress.address = pickuplocation;
//                     customerAddress.landMark = landmark.text;
//                     customerAddress.fkAreaId = dropdownValue;
//                     customerAddress.fkCustomerId = widget.customer.customerId;
//                     customerAddress.longitude = widget.customer.longitude;
//                     customerAddress.latitude = widget.customer.latitude;
//
//                     int sc = await itemscontroller()
//                         .addNewAddress(customerAddress);
//
//                     if (sc == 200) {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => EditScreen(widget.customer,widget.allAreas)));
//                       setState(() {});
//                     } else {
//                       Globle().Errormsg(context, "Error, Please try again");
//                     }
//                   },
//                   colors: CustomColors().mainThemeColor,
//                   styl: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   pickCurrentLocation() async {
//     Position? position = await currentLocation.getCurrentLocation(context);
//     if (position != null) {
//       // Get the address based on the latitude and longitude
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       Placemark placemark = placemarks[0];
//       String address =
//           "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
//
//       setState(() {
//         pickuplocation = address;
//         widget.customer.latitude = position.latitude;
//         widget.customer.longitude =position.longitude;
//       });
//     }
//   }
// }
