import 'dart:convert';

import 'package:yoracustomer/GlobleVariables/Globle.dart';
import 'package:yoracustomer/Model/ChatMessage.dart';
import 'package:http/http.dart' as http;

import '../LinkFiles/EndPoints.dart';
import '../Services/ApiResponse.dart';
import '../Services/ApiService.dart';

class ChatsController{
  // Get all messages,
  Future<List<ChatMessage>> getMessages(int oid, String receiverType)  async {
    print(oid);
    ApiResponse res = ApiResponse();
    ApiService apiService = ApiService();
    res = await apiService.GetData("${EndPoints.apiPath}ChatMessages/GetMessages?senderId=${Globle.customerid}&senderType=c&receiverType=$receiverType&orderId=$oid");
    List<ChatMessage> messages = [];
    if (res.StatusCode == 0) {
    } else if (res.StatusCode == 200) {
      List data = res.Response;
      messages = data.map<ChatMessage>((json) => ChatMessage.fromJson(json)).toList();
    }
    return messages;
  }

  Future <int> sendMessage (ChatMessage message) async {
    var url = "${EndPoints.apiPath}ChatMessages/SendMessage";
    String? body = json.encode(message.toJson());
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: body
    );
    return res.statusCode;
  }

  Future<int> getUnreadMessages (int oid,String senderType) async {
    var url = "${EndPoints.apiPath}ChatMessages/UnreadMessages?orderId=$oid&receiverType=c&userId=${Globle.customerid}&senderType=$senderType";
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    return int.parse(res.body);
  }
  Future<int> markMessageRead (int oid,String senderType) async {
    var url = "${EndPoints.apiPath}ChatMessages/MessageRead?orderId=$oid&receiverType=c&userId=${Globle.customerid}&senderType=$senderType";
    http.Response res = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    return res.statusCode;
  }

}