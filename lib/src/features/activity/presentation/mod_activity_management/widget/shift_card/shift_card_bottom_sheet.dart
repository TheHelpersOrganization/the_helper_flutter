import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class ShiftCardBottomSheet extends StatelessWidget {
  final Shift shift;

  const ShiftCardBottomSheet({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
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
        const ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('Edit'),
        ),
        const ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Delete'),
        ),
      ],
    );
  }
}
