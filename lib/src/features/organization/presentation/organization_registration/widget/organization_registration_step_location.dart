import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/country_picker.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/config/config.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/screen/location_picker_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/controller/organization_registration_controller.dart';

final organizationRegistrationStepLocationFormKey =
    GlobalKey<FormBuilderState>();

class OrganizationRegistrationStepLocation extends ConsumerWidget {
  const OrganizationRegistrationStepLocation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeProvider);

    return FormBuilder(
      key: organizationRegistrationStepLocationFormKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'addressLine1',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g 268 Ly Thuong Kiet Street, Ward 14',
              label: Text('Address Line'),
              helperText: 'Street No, Street Name, Ward',
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          FormBuilderTextField(
            name: 'locality',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g District 10',
              label: Text('District / City'),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          FormBuilderTextField(
            name: 'region',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g Ho Chi Minh City',
              label: RequiredText('City / Province'),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          FormFieldCountryPicker(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Pick a country',
              label: RequiredText('Country'),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
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
              ref.read(placeProvider.notifier).state = place;
              final components = place.addressComponents;
              if (components == null) {
                return;
              }
              final fields = organizationRegistrationStepLocationFormKey
                  .currentState!.fields;
              if (components.isNotEmpty) {
                fields['country']!.didChange(
                  components[components.length - 1].longName,
                );
              }
              if (components.length > 1) {
                fields['region']!.didChange(
                  components[components.length - 2].longName,
                );
              }
              if (components.length > 2) {
                fields['locality']!.didChange(
                  components[components.length - 3].longName,
                );
              }
              if (components.length > 3) {
                fields['addressLine1']!.didChange(
                  components
                      .slice(0, components.length - 3)
                      .map((element) => element.longName)
                      .join(', '),
                );
              }
            },
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Pick Location'),
          ),
          const SizedBox(
            height: 32,
          ),
          if (AppConfig.isDevelopment)
            Column(
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    final fields = organizationRegistrationStepLocationFormKey
                        .currentState!.fields;
                    fields['addressLine1']!
                        .didChange('268 Ly Thuong Kiet Street, Ward 14');
                    fields['locality']!.didChange('District 10');
                    fields['region']!.didChange('Ho Chi Minh City');
                    fields['country']!.didChange('Vietnam');
                  },
                  label: const Text('Fill Test Data'),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
        ].sizedBoxSpacing(const SizedBox(
          height: 12,
        )),
      ),
    );
  }
}
