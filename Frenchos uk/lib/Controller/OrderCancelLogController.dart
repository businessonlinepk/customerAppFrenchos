import 'package:yoracustomer/Model/OrderCancelLog.dart';
import 'package:yoracustomer/Model/OrderCancelOption.dart';

import '../Model/OrderLog.dart';
import '../Services/ApiResponse.dart';
import '../Services/ApiService.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../LinkFiles/EndPoints.dart';

class OrderCancelLogController{
  Future<List<OrderCancelOption>?> getCancelOptions()  async {
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData(EndPoints.apiPath+"OrderCancelLog");
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      List<OrderCancelOption> logs = data.map<OrderCancelOption>((json) => OrderCancelOption.fromJson(json)).toList();
      logs = logs.where((element) => element.optionFor).toList();
      return logs;
    }
    return null;
  }

  Future<int> addLog(OrderCancelLog log)  async {
    String? body = json.encode(log.toJson());
    var url = EndPoints.apiPath+"OrderCancelLog/addlog";
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: body,
    );
    return res.statusCode;
  }

  Future<int> addOrderLog (OrderLog? o) async{
    if (o != null) {
      String? body = json.encode(o.toJson());
      http.Response response = await http.post(
        Uri.parse(EndPoints.apiPath+"Orders/AddOrderLog"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: body,
      );
      if (response.statusCode == 200) {
        return 200;
      }
      else {
        return 404;
      }
    }
    else {
      return 201;
    }
  }

}