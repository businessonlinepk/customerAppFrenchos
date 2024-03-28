import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yoracustomer/Homepage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'GlobleVariables/Globle.dart';
import 'ReviewDetail.dart';
import 'Services/CureentLocationFunction.dart';
import 'package:google_maps_webservice/places.dart';
import '../LinkFiles/CustomColors.dart';
import 'LinkFiles/EndPoints.dart';

class SignupPage extends StatefulWidget {
  SignupPage(this.contactNumber);

  final String contactNumber;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController fname = TextEditingController();

  TextEditingController emname = TextEditingController();

  TextEditingController Ctname = TextEditingController();

  // TextEditingController addname = TextEditingController();

  TextEditingController lname = TextEditingController();
  String pickuplocation = "";

  bool _validate = false;
  bool _validate1 = false;
  String dropdownvalue = 'Islamabad';
  var items = [
    'Islamabad',
    'Rawalpindi',
  ];
  final currentLocation = CurrentLocationFunction();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Ctname.text = widget.contactNumber.toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Create an Account,Its free",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            makeInputName(label: "Name*"),
                            makeInputContact(
                                label: "Contact", obsureText: true),
                            makeInputEmail(label: "Email"),

                            // makeInputcity(label: "Select your City", obsureText: true),
                            // SizedBox(height: 14,),
                            // Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("City")),
                            // SizedBox(height: 8,),
                            // // getCity(),
                            // SizedBox(height: 20,),
                            makeInputAddress(
                                label: "Address", obsureText: true),
                            makeInputLandmark(
                                label: "Landmark", obsureText: true),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),

                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: CustomColors().mainThemeColor,
                            child: TextButton(
                              onPressed: () {
                                if (fname.text.isEmpty) {
                                  String msg =
                                      "please fill up the required field";
                                  Globle().Errormsg(context, msg);
                                }
                                // }else if(emname.text.isEmpty){
                                //   String msg="please fill up the required field";
                                //   Globle().Errormsg(context,msg);
                                //
                                // }

                                else {
                                  print("callinnng");
                                  signupapi();
                                }

                                setState(() {
                                  if (fname.text.isEmpty) {
                                    _validate = true;
                                  } else {
                                    _validate = false;
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) =>  findlocaton()));
                                  }
                                  // if (emname.text.isEmpty){
                                  //   _validate1 = true;
                                  // } else {
                                  //   _validate1 = false;
                                  // }
                                });
                              },
                              child: Text("Sign up"),
                            ),
                          ),
                          // MaterialButton(
                          //   minWidth: double.infinity,
                          //   height:40,
                          //   onPressed: (){
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(builder: (context) =>  findlocaton()));
                          //   },
                          //   color: Colors.redAccent,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(40)
                          //   ),
                          //   child: Text("Sign Up",style: TextStyle(
                          //     fontWeight: FontWeight.w600,fontSize: 16,
                          //
                          //   ),),
                          // ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  makeInputName({label, obsureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: fname,
          obscureText: obsureText,
          decoration: InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: "etc: Ali "),
          enabled: true,
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  makeInputEmail({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: emname,
          // _validate ? 'Value Can\'t Be Empty' : null,
          // enabled: false,
          decoration: InputDecoration(
            errorText: _validate1 ? 'field Can\'t Be Empty' : null,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  makeInputContact({required String label, required bool obsureText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          enabled: false,
          controller: Ctname,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            prefixText: "923",
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            // hintText: "0301*******"
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  makeInputAddress({required String label, required bool obsureText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
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
              /*final plist = GoogleMapsPlaces(
                apiKey: kGoogleApiKey,
                apiHeaders: await const GoogleApiHeaders().getHeaders(),
                //from google_api_headers package
              );
              String placeid = place.placeId ?? "0";
              final detail = await plist.getDetailsByPlaceId(placeid);
              final geometry = detail.result.geometry!;*/
              // picklat = geometry.location.lat;
              // picklng = geometry.location.lng;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  title: Text(
                    pickuplocation,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18.0),
                    maxLines: 2,
                  ),
                  trailing: const Icon(Icons.search),
                  dense: true,
                )),
          ),
        ),
        // TextField(
        //   onTap: (){
        //
        //   },
        //   controller: addname,
        //   obscureText: false,
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: Colors.grey,
        //       ),
        //     ),
        //     border:
        //         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        //     // label: Text("Email"),
        //     hintText: " etc : House No 2,Stret no 23",
        //
        //   ),
        //
        // ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  makeInputLandmark({required String label, required bool obsureText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: lname,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            hintText: "Famouse place near you",
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  getCity() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        height: 50,
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
    );
  }

  Future<void> signupapi() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse(EndPoints.apiPath +'Customers/Create'));
    request.body = json.encode({
      "customerId": 0,
      "fkCityId": 0,
      "fkRestaurantId": EndPoints.Resturantid,
      "name": fname.text.toString(),
      "email": emname.text.toString(),
      "contact": "923" + Ctname.text.toString(),
      "address": pickuplocation.toString(),
      "landmark": lname.text.toString(),
      "dateAdded": "2022-12-22T08:58:09.142Z",
      "isActive": true,
      "isDeleted": true
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else if (response.statusCode == 405) {
      String msg = "Email already registered please choose another one";
      Globle().Errormsg(context, msg);
    }
    // else if(emname.text.isEmpty){
    //   String msg="Email required";
    //   Globle().Errormsg(context,msg);
    // }

    else {
      print(response.reasonPhrase);
    }
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
        // picklat=position.latitude;
        // picklng=position.longitude;
      });
    }
  }
}
