import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/location/data/location_repository.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete_query.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/domain/place_details_query.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode_query.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/controller/location_controller.dart';

class LocationPickerScreen extends ConsumerWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);
    final mapControllerNotifier = ref.watch(mapControllerProvider.notifier);
    final position = ref.watch(initialLocationProvider);
    final currentLatLngNotifier = ref.watch(currentLatLngProvider.notifier);
    final currentLatLng = ref.watch(currentLatLngProvider);
    final locationRepository = ref.watch(locationRepositoryProvider);
    final textEditingController = ref.watch(textEditingControllerProvider);
    final sessionToken = ref.watch(sessionTokenProvider);
    final currentPlace = ref.watch(currentPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: context.theme.colorScheme.outline,
            width: 1,
          ),
        ),
        title: const Text('Pick Location'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (currentPlace == null ||
                  currentPlace.longitude == null ||
                  currentPlace.latitude == null) {
                context.pop(currentPlace);
                return;
              }
              if (currentPlace.formattedAddress == null) {
                final reverseGeocodes =
                    await locationRepository.reverseGeocodeQuery(
                  query: ReverseGeocodeQuery(
                    longitude: currentPlace.longitude!,
                    latitude: currentPlace.latitude!,
                  ),
                );
                if (!context.mounted) {
                  return;
                }
                final reverseGeocode =
                    reverseGeocodes.isNotEmpty ? reverseGeocodes.first : null;
                if (reverseGeocode == null) {
                  context.pop(currentPlace);
                  return;
                }
                final place = PlaceDetails(
                  formattedAddress: reverseGeocode.formattedAddress,
                  addressComponents: reverseGeocode.addressComponents,
                  latitude: currentPlace.latitude,
                  longitude: currentPlace.longitude,
                );
                return context.pop(place);
              }
              context.pop(currentPlace);
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          )
        ],
      ),
      body: position.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: CustomErrorWidget(
            onRetry: () {
              ref.invalidate(initialLocationProvider);
              ref.invalidate(mapControllerProvider);
              ref.invalidate(currentLatLngProvider);
            },
          ),
        ),
        data: (data) {
          final latlng = LatLng(data.latitude, data.longitude);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: FormBuilderTypeAhead<PlaceAutocomplete>(
                  name: 'location',
                  controller: textEditingController,
                  itemBuilder: (context, itemData) => ListTile(
                    title: Text(itemData.description),
                  ),
                  suggestionsCallback: (pattern) {
                    return ref
                        .read(locationRepositoryProvider)
                        .placeAutocompleteQuery(
                          query: PlaceAutocompleteQuery(
                            input: pattern,
                            sessionToken: sessionToken,
                          ),
                        );
                  },
                  onSuggestionSelected: (suggestion) {
                    locationRepository
                        .placeDetailsQuery(
                      query: PlaceDetailsQuery(
                        placeId: suggestion.placeId,
                        sessionToken: sessionToken,
                      ),
                    )
                        .then((value) {
                      if (value.latitude == null || value.longitude == null) {
                        return;
                      }
                      final updatedLatLng =
                          LatLng(value.latitude!, value.longitude!);
                      currentLatLngNotifier.state = updatedLatLng;
                      ref.invalidate(sessionTokenProvider);
                      ref.read(currentPlaceProvider.notifier).state = value;
                      mapController?.animateCamera(
                        CameraUpdate.newLatLng(updatedLatLng),
                      );
                    });
                  },
                  selectionToTextTransformer: (suggestion) =>
                      suggestion.description,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Search locations',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () => textEditingController.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GoogleMap(
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
                    ref.invalidate(sessionTokenProvider);
                    ref.read(currentPlaceProvider.notifier).state =
                        PlaceDetails(
                      latitude: latlng.latitude,
                      longitude: latlng.longitude,
                    );
                    mapController
                        ?.animateCamera(CameraUpdate.newLatLng(latlng));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
