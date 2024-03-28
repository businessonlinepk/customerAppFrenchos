import 'dart:convert';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../LinkFiles/CustomColors.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Controller/itemscontroller.dart';
import 'Homepage.dart';
import 'Model/Customer.dart';
import 'LinkFiles/EndPoints.dart';
import 'Services/CureentLocationFunction.dart';
const kGoogleApiKey = "AIzaSyCLFYsLuixpirWLa--cSHA3RPwc9-dGprk";

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  // TextEditingController dateinput = TextEditingController();
  TextEditingController fname = TextEditingController();

  // TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController secondContact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController landmark = TextEditingController();
  Customer customer = Customer(dateAdded: DateTime.now());
  final currentLocation = CurrentLocationFunction();
  String pickuplocation = "";
  String dropdownvalue = 'Islamabad';
  var items = [
    'Islamabad',
    'Rawalpindi',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  // dateinput.text = "";
  // super.initState();
  // PersInfoApi();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: CustomColors().mainThemeColor,
          centerTitle: true,
          title: Text("Profile",style: TextStyle(color: CustomColors().mainThemeTxtColor),),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: fname,
                // enabled: false,
                onChanged: (val){
                  customer.name = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (const BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'First Name',
                  labelText: 'First Name',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: email,
                // enabled: false,
                onChanged: (val){
                  customer.email = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: contactno,
                 enabled: false,
                onChanged: (val){
                  customer.contact = val;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (const BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Contact Number',
                  labelText: 'Contact Number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: secondContact,
                onChanged: (val){
                  customer.secondaryContact = val;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter your other contact',
                  labelText: 'Other Number',
                ),
              ),
            ),
            //getCity(),

            /*Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: address,
                // enabled: true,
                onChanged: (val){
                  customer.address = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (const BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter your Address',
                  labelText: 'Address',
                ),
              ),
            ),*/
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
                    customer.latitude = geometry.location.lat;
                    customer.longitude = geometry.location.lng;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: TextField(
                controller: landmark,
                // enabled: true,
                onChanged: (val){
                  customer.landmark = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: (const BorderSide(color: Colors.black38, width: 1)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter your Nearest Place',
                  labelText: 'Other detail (optional)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 8, bottom: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: CustomColors().mainThemeColor,
                child: TextButton(
                    onPressed: () async {
                      int sc = await itemscontroller().updateprofile(customer);
                      if(sc == 200)
                        {
                          Globle().Succesmsg(context, "Profile updated");
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Homepage()));
                        }
                      else
                        {
                          Globle().Errormsg(context, "Server error, Please try again later");
                        }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),

          ],
        ),
      ),
    );
  }

  getCity() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black45),
            ),
            child: DropdownButton2(
              isExpanded: true,
              // buttonHeight: 80,
              // buttonWidth: 250,
              value: dropdownvalue,

              // Down Arrow Icon
              hint: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),

              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getdata() async {
    var request = http.Request(
        'GET',
        Uri.parse('${EndPoints.apiPath}Customers/GetUser/${Globle.customerid}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseString = await response.stream.bytesToString();
      final res = json.decode(responseString);
      customer = Customer.fromJson(res);

      fname.text = res["name"];
      email.text = res["email"];
      contactno.text = res["contact"];
      secondContact.text = res["secondaryContact"];
      address.text = res["address"];
      landmark.text = res["landmark"];
    } else {
      print(response.reasonPhrase);
    }
    setState(() {});
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
        customer.address = pickuplocation = address;
        customer.latitude = position.latitude;
        customer.longitude =position.longitude;
      });
    }
  }
}
