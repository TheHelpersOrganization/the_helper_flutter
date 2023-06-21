import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/utils/location.dart';

class MyShiftCard extends ConsumerWidget {
  final Shift shift;

  const MyShiftCard({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = shift.startTime;
    String participants = shift.joinedParticipants.toString();
    if (shift.numberOfParticipants != null) {
      participants += '/${shift.numberOfParticipants} Participants';
    } else {
      participants += ' Participants';
    }
    final myVolunteer = shift.myShiftVolunteer;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                shift.name,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                shift.activity?.name ?? 'Unknown Activity',
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              // Wrap it with flexible to detect overflow
              Flexible(
                child: AutoSizeText(
                  getAddress(
                    shift.locations?.isNotEmpty == true
                        ? shift.locations!.first
                        : null,
                  ),
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                  ),
                  maxLines: 2,
                  overflowReplacement: Text(
                    getAddress(
                      shift.locations?.isNotEmpty == true
                          ? shift.locations!.first
                          : null,
                      componentCount: 2,
                    ),
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(startTime.formatDayMonthYearBulletHourSecond()),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  const Icon(Icons.supervisor_account),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(participants),
                ],
              ),
              if (myVolunteer != null && shift.status == ShiftStatus.ongoing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        if (myVolunteer.checkedIn == true)
                          const Label(
                              labelText: 'Checked-in', color: Colors.green)
                        else
                          const Label(
                              labelText: 'Not checked-in', color: Colors.red),
                        if (myVolunteer.checkedOut == true)
                          const Label(
                              labelText: 'Checked-out', color: Colors.green)
                        else
                          const Label(
                              labelText: 'Not checked-out', color: Colors.red)
                      ].sizedBoxSpacing(const SizedBox(width: 4)),
                    ),
                  ],
                ),
              // if (activity.me?.isManager == true ||
              //     activity.me?.isShiftManager == true)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Divider(),
              //       const SizedBox(
              //         height: 4,
              //       ),
              //       Row(
              //         children: [
              //           if (activity.me?.isManager == true)
              //             const Label(
              //               labelText: 'Activity manager',
              //               color: Colors.deepOrange,
              //             ),
              //           if (activity.me?.isShiftManager == true)
              //             Label(
              //               labelText: 'Shift manager',
              //               color: context.theme.primaryColor,
              //             ),
              //         ].sizedBoxSpacing(
              //           const SizedBox(
              //             width: 4,
              //           ),
              //         ),
              //       ),
              //       if (activity.me?.shiftManagerCount != null &&
              //           activity.me!.shiftManagerCount! > 0)
              //         Padding(
              //           padding: const EdgeInsets.only(top: 8),
              //           child: Text(
              //             'You are shift manager for ${activity.me!.shiftManagerCount} shift(s)',
              //           ),
              //         ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
