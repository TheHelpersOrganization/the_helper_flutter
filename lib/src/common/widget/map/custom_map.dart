import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends ConsumerWidget {
  final EdgeInsets padding;

  const CustomMap({
    super.key,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Web support is terrible
    // if (kIsWeb) {
    //   return const SizedBox.shrink();
    // }
    final mapController = ref.watch(mapControllerProvider);
    final mapControllerNotifier = ref.watch(mapControllerProvider.notifier);
    final position = ref.watch(initialLocationProvider);
    final currentLatLngNotifier = ref.watch(currentLatLngProvider.notifier);
    final currentLatLng = ref.watch(currentLatLngProvider);

    return position.when(
      data: (data) {
        final latlng = LatLng(data.latitude, data.longitude);
        return GoogleMap(
          padding: padding,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: latlng,
            zoom: 18.0,
          ),
          onMapCreated: (controller) {
            mapControllerNotifier.state = controller;
          },
          markers: {
            Marker(
              markerId: markerId,
              position: currentLatLng ?? latlng,
            )
          },
          onTap: (latlng) {
            currentLatLngNotifier.state = latlng;
            mapController?.animateCamera(CameraUpdate.newLatLng(latlng));
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(
        child: Text('Error'),
      ),
    );
  }
}

const markerId = MarkerId('map-marker');

final mapControllerProvider =
    StateProvider.autoDispose<GoogleMapController?>((ref) => null);

final currentLatLngProvider = StateProvider.autoDispose<LatLng?>((ref) => null);

final initialLocationProvider =
    FutureProvider.autoDispose<Position>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
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
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return Geolocator.getCurrentPosition();
});
