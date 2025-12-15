import 'package:geolocator/geolocator.dart';

/// Utility class for location-related operations.
///
/// Provides methods for retrieving the user's current location
/// and calculating distances between two geographic coordinates.
class LocationHelper {
  static Future<Position?> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000; // in km
  }
}
