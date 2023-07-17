import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/location/data/location_repository.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';

enum LocationType {
  locality,
  region,
  country,
}

class LocationFilterData {
  final String label;
  final String value;
  final LocationType type;

  const LocationFilterData({
    required this.label,
    required this.value,
    required this.type,
  });

  @override
  int get hashCode => Object.hash(label, value, type);

  @override
  bool operator ==(Object other) {
    return other is LocationFilterData &&
        label == other.label &&
        value == other.value &&
        type == other.type;
  }
}

final activityQueryProvider = StateProvider.autoDispose<ActivityQuery?>(
  (ref) {
    ref.onDispose(() {
      ref.invalidate(selectedSkillsProvider);
      ref.invalidate(selectedOrganizationsProvider);
      ref.invalidate(selectedStartTimeProvider);
      ref.invalidate(selectedEndTimeProvider);
      ref.invalidate(radiusTextEditingControllerProvider);
      ref.invalidate(isLocationFilterSimpleModeProvider);
      ref.invalidate(placeProvider);
      ref.invalidate(selectedLocationProvider);
    });
    return null;
  },
);
final isMarkedToResetProvider = StateProvider.autoDispose<bool>((ref) => false);

final skillsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(skillRepositoryProvider).getSkills(),
);

final selectedSkillsProvider = StateProvider<Set<Skill>>((ref) => {});

final organizationsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(organizationRepositoryProvider).getAll(),
);

final selectedOrganizationsProvider =
    StateProvider<Set<Organization>>((ref) => {});

final selectedStartTimeProvider = StateProvider<DateTime?>(
  (ref) => null,
);
final selectedEndTimeProvider = StateProvider<DateTime?>(
  (ref) => null,
);

final radiusTextEditingControllerProvider =
    ChangeNotifierProvider<TextEditingController>(
  (ref) => TextEditingController(),
);
final isLocationFilterSimpleModeProvider = StateProvider<bool>((ref) => true);
final placeProvider = StateProvider<PlaceDetails?>((ref) => null);
final selectedLocationProvider =
    StateProvider<LocationFilterData?>((ref) => null);

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

final initialLocationProvider =
    FutureProvider.autoDispose<ReverseGeocode?>((ref) async {
  final link = ref.keepAlive();
  Timer? timer;
  ref.onDispose(() {
    timer?.cancel();
  });
  // When the last listener is removed, start a timer to dispose the cached data
  ref.onCancel(() {
    // start a 5-minute timer
    timer = Timer(const Duration(minutes: 5), () {
      // dispose on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    print('Location services are disabled. Returning default location.');
    final res = await ref.read(locationRepositoryProvider).reverseGeocodeQuery(
          query: ReverseGeocodeQuery(
            latitude: defaultLocation.latitude,
            longitude: defaultLocation.longitude,
          ),
        );
    return res.firstOrNull;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    print('Location permission is denied forever. Returning default location.');
    final res = await ref.read(locationRepositoryProvider).reverseGeocodeQuery(
          query: ReverseGeocodeQuery(
            latitude: defaultLocation.latitude,
            longitude: defaultLocation.longitude,
          ),
        );
    return res.firstOrNull;
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      print('Location permission is denied. Returning default location.');
      final res =
          await ref.read(locationRepositoryProvider).reverseGeocodeQuery(
                query: ReverseGeocodeQuery(
                  latitude: defaultLocation.latitude,
                  longitude: defaultLocation.longitude,
                ),
              );
      return res.firstOrNull;
    }
  }

  final pos = await Geolocator.getCurrentPosition();

  final res = await ref.read(locationRepositoryProvider).reverseGeocodeQuery(
        query: ReverseGeocodeQuery(
          latitude: pos.latitude,
          longitude: pos.longitude,
        ),
      );

  return res.firstOrNull;
});
