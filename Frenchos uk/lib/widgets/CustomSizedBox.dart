import 'package:flutter/cupertino.dart';

class ReusableSizedBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;

  const ReusableSizedBox({
    Key? key,
    required this.width,
    required this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

// Usage

