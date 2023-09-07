import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/screen/location_picker_screen.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/widget/river_location_autocomplete_field.dart';
import 'package:the_helper/src/utils/location.dart';

class ActivityLocationView extends ConsumerWidget {
  final Location? initialLocation;

  const ActivityLocationView({
    super.key,
    this.initialLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeProvider);
    final hasEditedLocation = ref.watch(hasEditedLocationProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Pick a city where the activity will take place. Manually type in or select a location on map'),
          const SizedBox(
            height: 12,
          ),
          if (initialLocation != null && !hasEditedLocation)
            Text(getAddress(initialLocation))
          else
            RiverLocationAutocompleteField.autoDispose(provider: placeProvider),
          const SizedBox(
            height: 12,
          ),
          FilledButton.tonalIcon(
            onPressed: () async {
              final PlaceDetails? place = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LocationPickerScreen(),
                ),
              );
              if (!context.mounted) {
                return;
              }
              if (place == null) {
                return;
              }
              print(place);
              ref.read(placeProvider.notifier).state = place;
              ref.read(hasEditedLocationProvider.notifier).state = true;
            },
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Pick Location'),
          ),
        ],
      ),
    );
  }
}
