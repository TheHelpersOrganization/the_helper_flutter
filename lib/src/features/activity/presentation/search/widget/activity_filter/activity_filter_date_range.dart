import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_filter_controller.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ActivityFilterDateRange extends ConsumerWidget {
  const ActivityFilterDateRange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStartTime = ref.watch(selectedStartTimeProvider);
    final selectedEndTime = ref.watch(selectedEndTimeProvider);

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Activity start/end time',
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FormBuilderDateTimePicker(
            useRootNavigator: false,
            name: 'startTime',
            initialValue: selectedStartTime,
            firstDate: DateTime.now().subtract(const Duration(days: 60)),
            lastDate: DateTime.now().add(const Duration(days: 180)),
            currentDate: DateTime.now(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.date_range_outlined),
              hintText: 'Select start time',
            ),
            onChanged: (value) {
              ref.read(selectedStartTimeProvider.notifier).state = value;
              if (value != null &&
                  selectedEndTime != null &&
                  value.isAfter(selectedEndTime)) {
                ref.read(selectedEndTimeProvider.notifier).state = value;
                _formKey.currentState?.fields['endTime']?.didChange(null);
              }
            },
          ),
          const SizedBox(height: 12),
          FormBuilderDateTimePicker(
            useRootNavigator: false,
            name: 'endTime',
            initialValue: selectedEndTime,
            initialDate: selectedStartTime ?? DateTime.now(),
            firstDate: selectedStartTime ?? DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 180)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.date_range_outlined),
              hintText: 'Select end time',
            ),
            onChanged: (value) =>
                ref.read(selectedEndTimeProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
