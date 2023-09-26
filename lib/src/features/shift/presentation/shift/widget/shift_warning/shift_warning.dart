import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_warning/overlapping_shift_bottom_sheet.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_warning/traveling_constrained_shift_bottom_sheet.dart';

class ShiftWarning extends StatelessWidget {
  final Shift shift;

  const ShiftWarning({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    if (shift.status != ShiftStatus.pending ||
        shift.myShiftVolunteer?.status == ShiftVolunteerStatus.approved ||
        (shift.overlaps?.isNotEmpty != true &&
            shift.travelingConstrainedShifts?.isNotEmpty != true)) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.deepOrange,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'This shift may not be suitable for you',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(text: '- Its working hours overlaps with ', children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  child: Text(
                    '${shift.overlaps!.length} shift(s)',
                    style: TextStyle(color: context.theme.primaryColor),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      context: context,
                      builder: (context) =>
                          OverlappingShiftBottomSheet(shift: shift),
                    );
                  },
                ),
              )
            ]),
            style: const TextStyle(color: Colors.deepOrange),
          ),
          const SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              text: '- You have registered for ',
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    child: Text(
                      '${shift.travelingConstrainedShifts!.length} shift(s)',
                      style: TextStyle(color: context.theme.primaryColor),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (context) =>
                            TravelingConstrainedShiftShiftBottomSheet(
                                shift: shift),
                      );
                    },
                  ),
                ),
                const TextSpan(
                  text:
                      ' that may not provide enough time to travel between this shift and other registered shift(s)',
                ),
              ],
            ),
            style: const TextStyle(color: Colors.deepOrange),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Tooltip(
            showDuration: const Duration(seconds: 5),
            triggerMode: TooltipTriggerMode.tap,
            message: 'This shift may not be suitable for you because:'
                '${shift.overlaps?.isNotEmpty == true ? '\n- Its working hours overlaps with ${shift.overlaps!.length} other shift(s)' : ''}'
                '${shift.travelingConstrainedShifts?.isNotEmpty == true ? '\n- You have registered for ${shift.travelingConstrainedShifts!.length} shift(s) that may not provide enough time to travel between this shift and other registered shift(s)' : ''}',
            child: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'This shift may not be suitable for you',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(Icons.help_outline),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
