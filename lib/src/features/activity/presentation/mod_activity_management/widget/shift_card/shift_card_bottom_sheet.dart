import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/delete_shift_dialog.dart';
import 'package:the_helper/src/router/router.dart';

class ShiftCardBottomSheet extends ConsumerWidget {
  final Shift shift;

  const ShiftCardBottomSheet({super.key, required this.shift});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityId = shift.activityId;
    final shiftId = shift.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            shift.name,
            style: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Shift details'),
          onTap: () {
            context.goNamed(AppRoute.organizationShift.name, pathParameters: {
              'activityId': shift.activityId.toString(),
              'shiftId': shift.id.toString(),
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Delete'),
          onTap: () {
            context.pop();
            showDialog(
              context: context,
              useRootNavigator: false,
              builder: (context) => DeleteShiftDialog(
                activityId: activityId,
                shiftId: shiftId,
              ),
            );
          },
        ),
      ],
    );
  }
}
