import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:yoracustomer/Controller/ChatsController.dart';
import 'package:flutter/material.dart';
import 'package:yoracustomer/Controller/itemscontroller.dart';

import 'GlobleVariables/Globle.dart';
import 'LinkFiles/CustomColors.dart';
import 'Model/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudfare;

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.oid,required this.receiverId, required this.receiverType}) : super(key: key);

  final int oid,receiverId;
  final String receiverType;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late Timer _timer;
  List<ChatMessage> messages = [];
  bool loadPage = false;
  TextEditingController newMessage = TextEditingController();
  bool msgReadCheck = false;
  bool btnPressed = false;
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
    startTimer();
    getToken();
    //readCheck();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  getToken() async {
   if(widget.receiverType == 'r')
     {
       cloudfare.DocumentSnapshot snapshot = await cloudfare
           .FirebaseFirestore.instance
           .collection("Riders")
           .doc(widget.receiverId.toString())
           .get();
       token= snapshot['token'];
     }
   if(widget.receiverType == 'c')
     {
       cloudfare.DocumentSnapshot snapshot = await cloudfare
           .FirebaseFirestore.instance
           .collection("Customers")
           .doc(widget.receiverId.toString())
           .get();
       token= snapshot['token'];
     }
  }
  getMessages() async {
    btnPressed = false;
    await ChatsController().markMessageRead(widget.oid, widget.receiverType);
    messages = await ChatsController().getMessages(widget.oid,widget.receiverType);
    if(messages.isNotEmpty)
    {
      setState(() {
        DateTime now = DateTime.now();
        DateTime twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
        messages = messages.where((message) => message.dateAdded.isAfter(twentyFourHoursAgo)).toList();
        loadPage = true;
        //readCheck();
      });
    }
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      await ChatsController().markMessageRead(widget.oid, widget.receiverType);
      messages = await ChatsController().getMessages(widget.oid,widget.receiverType);
      DateTime now = DateTime.now();
      DateTime twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
      messages = messages.where((message) => message.dateAdded.isAfter(twentyFourHoursAgo)).toList();
      setState(() {

      });
    });
  }
/*  readCheck(){
    if(msgReadCheck == false)
      {
        ChatMessage msg = ChatMessage(dateAdded: DateTime.now());
        try{
          msg = messages.firstWhere((element) => element.fkSenderId != Globle.customerid
              || element.fkReceiverId != Globle.customerid);
        }
        catch(e){}
        if(msg.messageId > 0)
          {
            msgReadCheck = true;
            if(msg.fkSenderId == Globle.customerid){
              ChatsController().messageRead(msg.fkOrderId, msg.fkReceiverId, msg.receiverType);
            }else{
              ChatsController().messageRead(msg.fkOrderId, msg.fkSenderId, msg.senderType);
            }
          }
      }
  }*/

  @override
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
            title: widget.receiverType == "x"? Text("Help Desk",style: TextStyle(color: CustomColors().mainThemeTxtColor),):
            widget.receiverType == "r"? Text("Chat with rider",style: TextStyle(color: CustomColors().mainThemeTxtColor),):
            Text("Chat with restaurant",style: TextStyle(color: CustomColors().mainThemeTxtColor),),),
          body: Stack(children: [
            buildTopWidget(), // list of data availbale widget
            // here is positioned its means total
          ])
      ),
    );
  }
  Widget buildTopWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG1.jpg'),
            fit: BoxFit.cover,
          )
      ),
      //height: MediaQuery.of(context).size.height * 0.55,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Visibility(
                  visible: loadPage,
                  replacement: const Center(
                    child: Text(
                      "Start your chat",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {

                        return messages[index].fkSenderId == Globle.customerid && messages[index].senderType == "c"?
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            decoration: BoxDecoration(
                              color: CustomColors().mainThemeColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].message,
                                  style: TextStyle(
                                    color: CustomColors().mainThemeTxtColor,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  messages[index].stringDate,
                                  style: TextStyle(
                                    color: CustomColors().mainThemeTxtColor,
                                    fontSize: 13,
                                  ),
                                ),
                                 if (messages[index].readCheck == true)
                                  const Icon(
                                    Icons.done_all,
                                    color: Colors.blue,
                                    size: 16,
                                  )
                                else
                                  const Icon(
                                    Icons.done_all,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        ):
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            decoration: BoxDecoration(
                              color: CustomColors().secondThemeColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].message,
                                  style: TextStyle(
                                    color: CustomColors().secondThemeTxtColor,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  messages[index].senderName.toUpperCase().trim(),
                                  style: TextStyle(
                                    color: CustomColors().secondThemeTxtColor,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  messages[index].stringDate,
                                  style: TextStyle(
                                    color: CustomColors().secondThemeTxtColor,
                                    fontSize: 13,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Container(
                color: CustomColors().mainThemeColor,
                //color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0,right: 6.0),
                      child: TextField(
                        maxLines: 2,
                        controller: newMessage,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: CustomColors().mainThemeColor,), // Set the focused border color
                          ),
                          // label:  Text("Message",style: TextStyle(color: CustomColors().mainBackgroundColor),),
                          border:  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            onPressed: (){

                              ChatMessage myMessage = ChatMessage(dateAdded: DateTime.now());
                              /*ChatMessage rMsg = ChatMessage(dateAdded: DateTime.now());
                              try{
                                rMsg = messages.firstWhere((element) => element.fkReceiverId == Globle.customerid && element.fkSenderId > 0);
                              }catch(e){
                              }
                              if(rMsg.messageId > 0)
                              {
                                myMessage.fkReceiverId = rMsg.fkSenderId;
                                myMessage.receiverType = rMsg.senderType;
                              }
                              else
                              {*/
                                myMessage.fkReceiverId = widget.receiverId;
                                myMessage.receiverType = widget.receiverType;
                              //}
                              myMessage.fkSenderId = Globle.customerid;
                              myMessage.senderType = 'c';
                              myMessage.message = newMessage.text;
                              myMessage.fkOrderId = widget.oid;
                              if(myMessage.message != "")
                              {
                                if(btnPressed == false){
                                  setState(() {
                                    btnPressed = true;
                                  });
                                  sendMessage(myMessage);
                                }
                                else{
                                  Globle().Infomsg(context, "Sending...");
                                }
                              }
                            }, icon:btnPressed? const Icon(Icons.send_and_archive_rounded,color: Colors.grey,): Icon(Icons.send,color: CustomColors().mainThemeColor,),
                          ),
                          hintText: 'Message',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ///Sending Notification for Chat between customer to Operator
  Future<void> sendMessage(ChatMessage message) async {
    int sc = await ChatsController().sendMessage(message);
    if(sc == 200)
    {
      int timeDifference = 3;
      try{
        timeDifference = DateTime.now().difference(messages.first.dateAdded).inHours;
      }catch(e){}
      var heading = "";
      if(timeDifference < 2)
      {
        heading = "New Message from customer (order# ${message.fkOrderId})";
      }
      else{
        heading = "New Message from customer (order# ${message.fkOrderId})";
      }
      itemscontroller().msgNotification(message.message,heading, token, widget.receiverType);
      newMessage.text = "";
    }
    else {
      if (kDebugMode) {
        print("Error");
      }
    }
    setState(() {
      getMessages();
    });
  }
}
