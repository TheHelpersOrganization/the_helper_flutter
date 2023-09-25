import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/location/data/location_repository.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode_query.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/screen/location_picker_screen.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/utils/location.dart';

import '../controller/organization_filter_controller.dart';

class OrganizationFilterLocation extends ConsumerWidget {
  const OrganizationFilterLocation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(radiusTextEditingControllerProvider);
    final place = ref.watch(placeProvider);
    final profile = ref.watch(profileProvider).asData?.value;
    final selectedLocation = ref.watch(selectedLocationProvider);
    final isSimpleMode = ref.watch(isLocationFilterSimpleModeProvider);

    final profileLocationLatitude = profile?.location?.latitude;
    final profileLocationLongitude = profile?.location?.longitude;

    final profileLocationRegion = profile?.location?.region;
    final currentLocation = ref.watch(initialLocationProvider).asData?.value;
    final addressComponents = currentLocation?.addressComponents;
    final address1 = addressComponents != null && addressComponents.length > 1
        ? addressComponents[addressComponents.length - 2].shortName
        : null;
    final address2 = addressComponents?.lastOrNull?.shortName;

    final Set<String> showedLocations = {};
    final List<LocationFilterData> locations = [];
    if (profileLocationRegion != null) {
      showedLocations.add(profileLocationRegion);
      locations.add(
        LocationFilterData(
          label: profileLocationRegion,
          value: profileLocationRegion,
          type: LocationType.region,
        ),
      );
    }
    if (address1 != null && !showedLocations.contains(address1)) {
      showedLocations.add(address1);
      locations.add(
        LocationFilterData(
          label: address1,
          value: address1,
          type: LocationType.region,
        ),
      );
    }
    if (address2 != null && !showedLocations.contains(address2)) {
      showedLocations.add(address2);
      locations.add(
        LocationFilterData(
          label: toCountryNameOrNull(address2) ?? address2,
          value: address2,
          type: LocationType.country,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Location',
                style: context.theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(isLocationFilterSimpleModeProvider.notifier).state =
                    !ref.read(isLocationFilterSimpleModeProvider);
                ref.read(selectedLocationProvider.notifier).state = null;
                ref.read(placeProvider.notifier).state = null;
                controller.clear();
              },
              icon: const Icon(
                Icons.swap_horiz_outlined,
              ),
              label: Text(
                isSimpleMode ? 'Simple' : 'Advanced',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isSimpleMode) ...[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text('In: '),
              ...locations.map(
                (e) => ChoiceChip(
                  label: Text(e.label),
                  selected: selectedLocation == e,
                  onSelected: (value) {
                    ref.read(selectedLocationProvider.notifier).state =
                        value ? e : null;
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (!isSimpleMode && place == null) ...[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Choose location radius: '),
              if (profileLocationLongitude != null &&
                  profileLocationLatitude != null) ...[
                TextButton(
                  onPressed: () async {
                    final res = (await ref
                            .read(locationRepositoryProvider)
                            .reverseGeocodeQuery(
                              query: ReverseGeocodeQuery(
                                  latitude: profileLocationLatitude,
                                  longitude: profileLocationLongitude),
                            ))
                        .firstOrNull;
                    final address = res?.formattedAddress ?? 'Unknown';
                    if (!context.mounted) {
                      return;
                    }
                    ref.read(placeProvider.notifier).state = PlaceDetails(
                      formattedAddress: address,
                      latitude: profileLocationLatitude,
                      longitude: profileLocationLongitude,
                    );
                  },
                  child: const Text(
                    'Use profile location',
                  ),
                ),
                const Text('or'),
              ],
              TextButton(
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
                  ref.read(placeProvider.notifier).state = place;
                },
                child: const Text(
                  'Pick location',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (!isSimpleMode && place != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  'Picked location: ${place.formattedAddress}',
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  ref.read(placeProvider.notifier).state = null;
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (!isSimpleMode)
          FormBuilderTextField(
            controller: controller,
            enabled: place != null,
            name: 'radius',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Radius (km)',
              helperText: 'The radius of the picked location (km)',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.numeric(),
            ]),
          )
      ],
    );
  }
}
