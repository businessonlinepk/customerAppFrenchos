import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderDialog extends StatelessWidget {
  const LoaderDialog(this.message) ;
 final String message;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*const CircularProgressIndicator(
                color: CustomColors().mainThemeColor,
                strokeWidth: 8,
              ),*/
              const Image(image: AssetImage(
              "assets/loading.gif"
              )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(message,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              ),

            ],
          )),
    );
  }
}

