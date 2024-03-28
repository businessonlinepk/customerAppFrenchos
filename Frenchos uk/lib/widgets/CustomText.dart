import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Alignment alimnt;

  ReusableText({
    required this.text,
    this.fontSize = 16,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
     this.alimnt=Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alimnt,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
