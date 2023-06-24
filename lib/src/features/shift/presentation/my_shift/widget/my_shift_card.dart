import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/ongoing_shift_bottom_sheet.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/upcoming_shift_bottom_sheet.dart';
import 'package:the_helper/src/utils/location.dart';
import 'package:the_helper/src/utils/shift.dart';

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
    if (shift.myShiftVolunteer == null) {
      print(shift.id);
      return const SizedBox.shrink();
    }
    final myVolunteer = shift.myShiftVolunteer!;
    final Widget? checkInLabelTrailing = myVolunteer.isCheckInVerified == true
        ? const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          )
        : myVolunteer.isCheckInVerified == false
            ? const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              )
            : null;
    final Widget checkInLabel = myVolunteer.checkedIn == true
        ? Label(
            labelText: 'Checked-in',
            color: Colors.green,
            trailing: checkInLabelTrailing,
          )
        : Label(
            labelText: 'Checked-in',
            color: Colors.red,
            trailing: checkInLabelTrailing,
          );
    final Widget? checkOutLabelTrailing = myVolunteer.isCheckOutVerified == true
        ? const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          )
        : myVolunteer.isCheckOutVerified == false
            ? const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              )
            : null;
    final Widget checkOutLabel = myVolunteer.checkedOut == true
        ? Label(
            labelText: 'Checked-out',
            color: Colors.green,
            trailing: checkOutLabelTrailing,
          )
        : Label(
            labelText: 'Checked-out',
            color: Colors.red,
            trailing: checkOutLabelTrailing,
          );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: () {
          if (shift.status == ShiftStatus.pending) {
            showModalBottomSheet(
              context: context,
              builder: (context) => UpcomingShiftBottomSheet(
                shift: shift,
                myVolunteer: myVolunteer,
              ),
              showDragHandle: true,
            );
            return;
          } else if (shift.status == ShiftStatus.ongoing) {
            showModalBottomSheet(
              context: context,
              builder: (context) => OngoingShiftBottomSheet(
                initialShift: shift,
              ),
              showDragHandle: true,
            );
          } else if (shift.status == ShiftStatus.completed) {
            showModalBottomSheet(
              context: context,
              builder: (context) => OngoingShiftBottomSheet(
                initialShift: shift,
              ),
              showDragHandle: true,
            );
          }
        },
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
              if (shift.status == ShiftStatus.ongoing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        checkInLabel,
                        checkOutLabel,
                      ].sizedBoxSpacing(const SizedBox(width: 4)),
                    ),
                  ],
                )
              else if (shift.status == ShiftStatus.pending)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 4,
                    ),
                    getShiftVolunteerStatusLabel(myVolunteer.status),
                  ],
                )
              else if (shift.status == ShiftStatus.completed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 4,
                    ),
                    Wrap(
                      children: [
                        checkInLabel,
                        checkOutLabel,
                        if (myVolunteer.reviewerId != null)
                          const Label(
                            labelText: 'Reviewed',
                            color: Colors.indigo,
                          ),
                      ].sizedBoxSpacing(const SizedBox(width: 4)),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
