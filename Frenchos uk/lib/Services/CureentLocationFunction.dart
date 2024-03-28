import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class CurrentLocationFunction{
  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      var location = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0, altitudeAccuracy: 0.0, headingAccuracy: 0.0);// Check if the user has granted permission
      //LocationPermission permission = await Geolocator.checkPermission();
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show a dialog explaining why the app needs the permission
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Location Permission Required'),
              content: Text(
                  'This app needs to access your device location to function properly.'),
              actions: [
                TextButton(
                  child: Text('Deny'),
                  onPressed: () =>
                      Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Allow'),
                  onPressed: () async {
                    Navigator.pop(context);
                    location = await Geolocator.getCurrentPosition();
                    print(location);
                  },
                ),
              ],
            ));
        return location;
      }

      // Request permission again
      if (permission == LocationPermission.deniedForever) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Location Permission Required'),
              content: Text(
                  'This app needs to access your device location to function properly. Please grant the location permission in the app settings.'),
              actions: [
                TextButton(
                  child: Text('Deny'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Allow'),
                  onPressed: () {
                    Navigator.pop(context);
                    //Geolocator.openAppSettings().;
                    Geolocator.requestPermission();
                  },
    ),
    ],

            ));
        return null;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}