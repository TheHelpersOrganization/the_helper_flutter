import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card_bottom_sheet.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card_footer.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

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
          context.goNamed(AppRoute.organizationShift.name, pathParameters: {
            'activityId': shift.activityId.toString(),
            'shiftId': shift.id.toString(),
          });
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
                title: Text(
                  shift.name,
                  style: context.theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
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
                height: 12,
              ),
              ShiftCardFooter(skills: shift.shiftSkills!),
            ],
          ),
        ),
      ),
    );
  }
}
