import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModActivityShiftManagementScreen extends ConsumerWidget {
  final int activityId;

  const ModActivityShiftManagementScreen({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(),
    );
  }
}
