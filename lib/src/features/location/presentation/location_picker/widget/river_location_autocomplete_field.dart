import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:the_helper/src/features/location/data/location_repository.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete_query.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/domain/place_details_query.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode_query.dart';
import 'package:the_helper/src/utils/location.dart';

final sessionTokenProvider = StateProvider.autoDispose<String>((ref) {
  return DateTime.now().millisecondsSinceEpoch.toString();
});

// Auto dispose by typeahead form builder
final textEditingControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => TextEditingController(),
);

class RiverLocationAutocompleteField extends ConsumerWidget {
  final StateProvider<PlaceDetails?>? provider;
  final AutoDisposeStateProvider<PlaceDetails?>? autoDisposeProvider;
  final int? maxComponents;

  const RiverLocationAutocompleteField({
    super.key,
    required StateProvider<PlaceDetails?> this.provider,
    this.maxComponents,
  }) : autoDisposeProvider = null;

  const RiverLocationAutocompleteField.autoDispose({
    super.key,
    required AutoDisposeStateProvider<PlaceDetails?> provider,
    this.maxComponents,
  })  : autoDisposeProvider = provider,
        provider = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionToken = ref.watch(sessionTokenProvider);
    final textEditingController = ref.watch(textEditingControllerProvider);
    final currentPlace = ref.watch(autoDisposeProvider ?? provider!);
    final currentLocation = currentPlace?.toLocationFromAddressComponents(
      maxComponents: maxComponents,
    );

    if (currentPlace != null) {
      return Row(
        children: [
          Expanded(child: Text(getAddress(currentLocation))),
          IconButton(
            onPressed: () {
              ref.read((autoDisposeProvider ?? provider!).notifier).state =
                  null;
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      );
    }

    return FormBuilderTypeAhead<PlaceAutocomplete>(
      name: 'location',
      //controller: textEditingController,
      itemBuilder: (context, itemData) => ListTile(
        title: Text(itemData.description),
      ),
      suggestionsCallback: (pattern) {
        return ref.read(locationRepositoryProvider).placeAutocompleteQuery(
              query: PlaceAutocompleteQuery(
                input: pattern,
                sessionToken: sessionToken,
              ),
            );
      },
      onSuggestionSelected: (suggestion) {
        Future<void> run() async {
          var value =
              await ref.read(locationRepositoryProvider).placeDetailsQuery(
                    query: PlaceDetailsQuery(
                      placeId: suggestion.placeId,
                      sessionToken: sessionToken,
                    ),
                  );

          if (value.latitude == null || value.longitude == null) {
            return;
          }

          if (value.formattedAddress == null ||
              value.addressComponents == null) {
            final reverseGeocode =
                (await ref.read(locationRepositoryProvider).reverseGeocodeQuery(
                          query: ReverseGeocodeQuery(
                            longitude: value.longitude!,
                            latitude: value.latitude!,
                          ),
                        ))
                    .firstOrNull;
            if (reverseGeocode != null) {
              value = value.copyWith(
                formattedAddress: reverseGeocode.formattedAddress,
                addressComponents: reverseGeocode.addressComponents,
              );
            }
          }

          if (autoDisposeProvider != null) {
            ref.read(autoDisposeProvider!.notifier).state = value;
          } else if (provider != null) {
            ref.read(provider!.notifier).state = value;
          }

          ref.read(sessionTokenProvider.notifier).state = DateTime.now()
              .millisecondsSinceEpoch
              .toString(); // invalidate session token
        }

        run();
      },

      selectionToTextTransformer: (suggestion) => suggestion.description,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Search locations',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            textEditingController.clear();
          },
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }
}
