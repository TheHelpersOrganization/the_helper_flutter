import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/utils/async_value.dart';

final shiftProvider = FutureProvider.autoDispose.family<Shift?, int>(
  (ref, id) => ref.watch(shiftRepositoryProvider).getShiftById(
        id: id,
      ),
);

class CheckInController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  CheckInController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> checkIn({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
        () => shiftRepository.checkInTest(shiftId: shiftId));
    if (!mounted) {
      return;
    }

    state = res;
  }
}

class CheckOutController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  CheckOutController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> checkOut({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.checkOutTest(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    state = res;
  }
}

final checkInControllerProvider =
    StateNotifierProvider.autoDispose<CheckInController, AsyncValue<void>>(
  (ref) => CheckInController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
final checkOutControllerProvider =
    StateNotifierProvider.autoDispose<CheckOutController, AsyncValue<void>>(
  (ref) => CheckOutController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
