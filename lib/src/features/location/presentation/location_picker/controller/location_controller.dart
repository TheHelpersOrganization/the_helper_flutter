import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';

const markerId = MarkerId('map-marker');

final defaultLocation = Position(
  latitude: 10.762622,
  longitude: 106.660172,
  altitude: 0,
  accuracy: 0,
  timestamp: DateTime.now(),
  heading: 0,
  speed: 0,
  speedAccuracy: 0,
);

final textEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final sessionTokenProvider = Provider.autoDispose<String>((ref) {
  return DateTime.now().millisecondsSinceEpoch.toString();
});

final mapControllerProvider =
    StateProvider.autoDispose<GoogleMapController?>((ref) => null);

final currentLatLngProvider = StateProvider.autoDispose<LatLng?>((ref) => null);
final currentPlaceProvider = StateProvider.autoDispose<PlaceDetails?>((ref) {
  return PlaceDetails(
    latitude: defaultLocation.latitude,
    longitude: defaultLocation.longitude,
  );
});

final initialLocationProvider =
    FutureProvider.autoDispose<Position>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return defaultLocation;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return defaultLocation;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return defaultLocation;
  }

  return Geolocator.getCurrentPosition();
});
