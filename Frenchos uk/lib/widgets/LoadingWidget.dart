import 'package:flutter/cupertino.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.msg
  });

  final String msg;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 90,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(
                "assets/loading.gif"
            )),
            msg != "" ?Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(msg,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18, overflow: TextOverflow.visible),),
            ):const SizedBox(height: 0,),
          ],
        ));
  }
}
