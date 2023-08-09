import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card_bottom_sheet.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card_skills.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/utils/shift.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;

  const ShiftCard({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) => ShiftCardBottomSheet(
              shift: shift,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    DateFormat('hh:mm dd/MM/yyyy').format(shift.startTime),
                    style: context.theme.textTheme.labelLarge?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  // child: Row(
                  //   children: [
                  //     Text(
                  //       shift.name,
                  //       style: context.theme.textTheme.bodyLarge
                  //           ?.copyWith(fontWeight: FontWeight.w500),
                  //     ),
                  //     const SizedBox(
                  //       width: 4,
                  //     ),
                  //     getShiftStatusLabel(shift.status),
                  //   ],
                  // ),
                  child: Text.rich(
                    TextSpan(
                      text: shift.name,
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const WidgetSpan(child: SizedBox(width: 4)),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: getShiftStatusLabel(shift.status),
                        )
                      ],
                    ),
                  ),
                ),
                subtitle: Text(
                  shift.description ?? 'No description',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      context: context,
                      builder: (context) => ShiftCardBottomSheet(
                        shift: shift,
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ShiftCardSkills(skills: shift.shiftSkills!),
              if (shift.me != null && shift.me!.isShiftManager == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        if (shift.me!.isShiftManager == true)
                          const Label(labelText: 'Shift Manager'),
                      ].sizedBoxSpacing(
                        const SizedBox(
                          width: 4,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
