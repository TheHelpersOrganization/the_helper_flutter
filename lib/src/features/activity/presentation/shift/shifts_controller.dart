import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/shift_repository.dart';

import '../../domain/shift.dart';

part 'shifts_controller.g.dart';

@riverpod
class Shifts extends _$Shifts {
  Future<List<Shift>> _fetchShifts(int activityId) async {
    final shifts =
        await ref.watch(shiftRepositoryProvider).getShifts(activityId);
    return shifts;
  }

  @override
  Future<List<Shift>> build(int activityId) async {
    return _fetchShifts(activityId);
  }
}
