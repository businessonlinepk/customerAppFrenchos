import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String okText;
  final Function? onOkPressed;

  ReusableAlertDialog({
    required this.title,
    required this.content,
    this.okText = "OK",
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(okText),
          onPressed: () {
            Navigator.of(context).pop();
            if (onOkPressed != null) {
              onOkPressed!();
            }
          },
        ),
      ],
    );
  }
}
