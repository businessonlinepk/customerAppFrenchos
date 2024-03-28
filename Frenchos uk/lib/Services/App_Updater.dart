// import 'package:flutter/material.dart';
// import 'package:upgrader/upgrader.dart';
// import 'dart:io';
//
// Future<void> inAppUpdateFunction(BuildContext context) async {
//   // // Get the app's version
//   // PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   // String appVersion = packageInfo.version;
//
//   //
//   // // Fetch the latest version from the Play Store
//   // String playStoreVersion = await getPlayStoreVersion();
//   // print("dddddddddd-----------"+playStoreVersion);
//   // print("sssssssss-----------"+appVersion);
//   //
//   // // Compare the app version with the Play Store version
//   // if (appVersion == playStoreVersion) {
//   //   print("No update required");
//   // } else if (appVersion.compareTo(minRequiredVersion) < 0) {
//   //   print("Minimum required version not met");
//   // } else {
//   //   print("Update required");
//   // Define the minimum required version
//   String minRequiredVersion = '1.1.18';
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     showDialog(
//       // barrierDismissible: false,
//       barrierColor: Colors.transparent,
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           // color: Colors.transparent,
//           child: UpgradeAlert(
//             // child: null,
//             upgrader: Upgrader(
//               showIgnore: false,
//               showLater: false,
//               showReleaseNotes: true,
//               canDismissDialog: false,
//               shouldPopScope: () => false,
//
//               durationUntilAlertAgain: Duration(seconds: 10),
//               dialogStyle: Platform.isAndroid
//                   ? UpgradeDialogStyle.material
//                   : UpgradeDialogStyle.cupertino,
//               minAppVersion: minRequiredVersion,
//               // Customize other parameters as needed
//             ),
//           ),
//         );
//       },
//     );
//   });
// }