import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderDialog1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
          height: 150,
          width: 150,
          child: Image(image: AssetImage(
          "assets/loading.gif"
          ),),),
    );
  }
}
