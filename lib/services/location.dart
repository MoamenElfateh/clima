import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      //1->>> Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location permission permanently denied. Please enable it in settings.';
      }

      //2->>> Check permission status
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied.';
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission permanently denied. Please enable it in settings.';
      }

      //3->>> Use LocationSettings instead of desiredAccuracy
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      //4->>> ignore: unused_local_variable
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }
}
