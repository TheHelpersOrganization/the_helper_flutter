import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shifts_controller.dart';

class ShiftsWidget extends ConsumerWidget {
  final int activityId;
  const ShiftsWidget({
    required this.activityId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftsProvider(activityId));
    return shifts.when(
      data: (shifts) => ListView(
        children: shifts
            .map((shift) => ListTile(
                  title: Text(shift.name!),
                ))
            .toList(),
      ),
      error: (Object error, StackTrace stackTrace) {
        print(stackTrace.toString());
        return Center(child: Text(error.toString()));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
