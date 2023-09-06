import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class TravelingConstrainedShiftShiftBottomSheet extends StatelessWidget {
  final Shift shift;

  const TravelingConstrainedShiftShiftBottomSheet({
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
              'Shifts',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'You may not have enough time to travel between the viewing shift and below shifts',
            ),
            const SizedBox(height: 12),
            ...shift.travelingConstrainedShifts!.map(
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
