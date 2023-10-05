import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/presentation/location_picker/screen/location_picker_screen.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/utils/location.dart';

class ShiftCreationBasicView extends ConsumerWidget {
  final GlobalKey<FormBuilderState> formKey;
  final int activityId;
  final Activity activity;
  final Shift? initialShift;

  const ShiftCreationBasicView({
    super.key,
    required this.formKey,
    required this.activityId,
    required this.activity,
    this.initialShift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParticipantLimited = ref.watch(isParticipantLimitedProvider);
    final startDate = ref.watch(startDateProvider);
    final locationTextEditingController =
        ref.watch(locationTextEditingControllerProvider);
    final PlaceDetails? place = ref.watch(placeProvider);
    final Location? activityLocation = activity.location;

    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(
            'Basic Info',
            style: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderTextField(
            name: 'name',
            initialValue: initialShift?.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter shift name',
              labelText: 'Name',
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(50),
            ]),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderTextField(
            name: 'description',
            initialValue: initialShift?.description,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: null,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(2000),
            ]),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Description'),
              hintText: 'Write about what your shift does',
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          Text(
            'Location',
            style: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Shift location must be located within the city/province of activity location: ${getAddress(activityLocation, componentCount: 2)}',
            style: TextStyle(color: context.theme.colorScheme.secondary),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderTextField(
            name: 'location',
            controller: locationTextEditingController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter location',
              labelText: 'Location',
              suffixIcon: IconButton(
                onPressed: () => locationTextEditingController.clear(),
                icon: const Icon(Icons.clear),
              ),
              helperText: 'Manually type in or select a location on map',
              helperMaxLines: 2,
              errorMaxLines: 2,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(1000),
              (text) {
                if (activity.location!
                    .contains(place!.toLocation(), components: 2)) {
                  return null;
                }
                return 'Shift location must be located within the city/province of activity location';
              },
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
              locationTextEditingController.text =
                  place.formattedAddress ?? locationTextEditingController.text;
              ref.read(placeProvider.notifier).state = place;
            },
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Pick Location'),
          ),
          const SizedBox(
            height: 36,
          ),
          FormBuilderSwitch(
            name: 'isParticipantLimited',
            title: Text(
              'Limit participants',
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            initialValue: initialShift?.numberOfParticipants != null,
            onChanged: (value) => ref
                .read(isParticipantLimitedProvider.notifier)
                .state = value ?? false,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderTextField(
            name: 'numberOfParticipants',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter number of participants',
              labelText: 'Number of Participants',
            ),
            enabled: isParticipantLimited ??
                initialShift?.numberOfParticipants != null,
            initialValue: initialShift?.numberOfParticipants?.toString(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              if (isParticipantLimited == true)
                FormBuilderValidators.required(),
              FormBuilderValidators.integer(),
              FormBuilderValidators.min(1),
            ]),
          ),
          const SizedBox(
            height: 36,
          ),
          Text(
            'Shift Time',
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderDateTimePicker(
            name: 'startTime',
            onChanged: (value) =>
                ref.read(startDateProvider.notifier).state = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Start Time',
              labelText: 'Start Time',
              suffixIcon: Icon(Icons.calendar_month_outlined),
            ),
            initialValue: initialShift?.startTime,
            firstDate: DateTime.now(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(
            height: 12,
          ),
          FormBuilderDateTimePicker(
            name: 'endTime',
            initialValue: initialShift?.endTime,
            initialDate: initialShift?.endTime ?? startDate ?? DateTime.now(),
            firstDate: startDate ?? DateTime.now(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'End Time',
              labelText: 'End Time',
              suffixIcon: Icon(Icons.calendar_month_outlined),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              (value) {
                final startTime = formKey
                    .currentState!.fields['startTime']!.value as DateTime;
                if (!value!.isAfter(startTime)) {
                  return 'End time must be after start time';
                }
                if (!DateUtils.isSameDay(startTime, value)) {
                  return 'End time must be on the same day as start time';
                }
                return null;
              },
            ]),
          ),
        ],
      ),
    );
  }
}
