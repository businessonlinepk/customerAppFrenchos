import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final Color colors;
  final TextStyle styl;
  final Function()? onPressed;

  const ReusableButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.colors,
    required this.styl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Colors.purpleAccent,
        backgroundColor: colors // Background Color
      ),
      child: Text(text,style:styl),
    );
  }
}


