import 'package:flutter/material.dart';

import 'LinkFiles/CustomColors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Order status",
              style: TextStyle(color: CustomColors().mainThemeTxtColor),
            ),
          ),
          backgroundColor: CustomColors().mainThemeColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   image: DecorationImage(image: AssetImage("assets/BG1.jpg")),
          // ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/loading.gif"), fit: BoxFit.cover,repeat: ImageRepeat.noRepeat),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
