import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class OverlappingShiftBottomSheet extends StatelessWidget {
  final Shift shift;

  const OverlappingShiftBottomSheet({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Overlapping shifts',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'The shift you are trying to add overlaps with the following shift:',
            ),
            const SizedBox(height: 12),
            ...shift.overlaps!.map(
              (e) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.name),
                trailing: FilledButton.tonal(
                  onPressed: () {
                    context.pushNamed(AppRoute.shift.name, pathParameters: {
                      AppRouteParameter.activityId: e.activityId.toString(),
                      AppRouteParameter.shiftId: e.id.toString(),
                    });
                  },
                  child: const Text('View'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
