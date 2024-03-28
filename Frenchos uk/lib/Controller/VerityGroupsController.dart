import 'dart:convert';

import '../GlobleVariables/Globle.dart';
import '../Model/CustomerAddress.dart';
import '../Model/VerityGroup.dart';
import '../LinkFiles/EndPoints.dart';
import '../services/ApiResponse.dart';
import '../services/ApiService.dart';
import 'package:http/http.dart' as http;

class VerityGroupsController{
  Future<List<VerityGroup>?> getVerityGroups(int iid) async {

    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData("${EndPoints.apiPath}VerityGroups/GetGroups/$iid");
    print(res.StatusCode);
    if (res.StatusCode == 0) {

    }
    else if (res.StatusCode == 200) {
      //print("veiritygroup");
      List data = res.Response;
      print(data);
      List<VerityGroup> verityGroups = data.map<VerityGroup>((json) =>
          VerityGroup.fromJson(json)).toList();
      return verityGroups;
    }
    return null;
  }

  Future<List<CustomerAddress>?>getCustomerAddresses() async {

    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"Customers/GetAddresses?cid="+ Globle.customerid.toString());
    print(res.StatusCode);
    if (res.StatusCode == 0) {

    }
    else if (res.StatusCode == 200) {
      //print("veiritygroup");
      List data = res.Response;
      print(data);
      List<CustomerAddress> addresses = data.map<CustomerAddress>((json) =>
          CustomerAddress.fromJson(json)).toList();
      return addresses;
    }
    return null;
  }

  Future<int> selectAddress(CustomerAddress address) async {
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(EndPoints.apiPath+"Customers/SelectAddress"));
    request.body = json.encode(address);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response.statusCode;

  }

  Future<void> addAddress(CustomerAddress address) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.apiPath+"Customers/AddAddress"));
    request.body = json.encode(address);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

}