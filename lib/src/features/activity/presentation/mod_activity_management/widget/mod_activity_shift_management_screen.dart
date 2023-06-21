import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

class ModActivityShiftManagementView extends ConsumerWidget {
  final List<Shift> shifts;

  const ModActivityShiftManagementView({
    super.key,
    required this.shifts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShiftManagerSelected = ref.watch(isShiftManagerSelectedProvider);
    final filteredShifts = shifts.where((element) {
      if (isShiftManagerSelected) {
        return element.me?.isShiftManager == true;
      }
      return true;
    }).toList();

    return filteredShifts.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4,
              ),
              CheckboxListTile(
                value: isShiftManagerSelected,
                onChanged: (value) {
                  ref.read(isShiftManagerSelectedProvider.notifier).state =
                      value ?? false;
                },
                title: const Text('Show shifts you manage'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              ...filteredShifts.map((e) => ShiftCard(shift: e)).toList(),
            ],
          )
        : Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CheckboxListTile(
                    value: isShiftManagerSelected,
                    onChanged: (value) {
                      ref.read(isShiftManagerSelectedProvider.notifier).state =
                          value ?? false;
                    },
                    title: const Text('Show shifts you manage'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Text(
                  'No shift found',
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                const Text('Tap "+ Shift" to add new shift')
              ],
            ),
          );
  }
}
