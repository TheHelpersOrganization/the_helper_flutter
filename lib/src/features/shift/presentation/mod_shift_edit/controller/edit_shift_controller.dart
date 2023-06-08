import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/update_shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/utils/async_value.dart';

class UpdateShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ModShiftRepository modShiftRepository;

  UpdateShiftController({
    required this.ref,
    required this.modShiftRepository,
  }) : super(const AsyncData(null));

  Future<void> updateShift(
      {required int id, required UpdateShift shift}) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
        () => modShiftRepository.updateShift(id: id, shift: shift));
    ref.invalidate(getActivityAndShiftsProvider);
    ref.invalidate(getActivityAndShiftProvider);
    if (!mounted) {
      return;
    }
    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }
    state = const AsyncValue.data(null);
  }
}

final updateShiftControllerProvider =
    StateNotifierProvider.autoDispose<UpdateShiftController, AsyncValue<void>>(
  (ref) => UpdateShiftController(
    ref: ref,
    modShiftRepository: ref.watch(modShiftRepositoryProvider),
  ),
);
