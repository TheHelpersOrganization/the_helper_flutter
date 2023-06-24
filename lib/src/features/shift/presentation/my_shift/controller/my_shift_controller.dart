import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/screen/my_shift_screen.dart';
import 'package:the_helper/src/utils/async_value.dart';

final isSearchingProvider = StateProvider.autoDispose((ref) => false);
final hasChangedProvider = StateProvider.autoDispose((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final tabTypeProvider = StateProvider.autoDispose((ref) => TabType.ongoing);

// Quick filter
final selectedStatusesProvider =
    StateProvider.autoDispose<Set<ShiftVolunteerStatus>>((ref) => {});

final queries = {
  TabType.ongoing: const ShiftQuery(
    status: [ShiftStatus.ongoing],
    myJoinStatus: [ShiftVolunteerStatus.approved],
    sort: [ShiftQuerySort.startTimeAsc],
  ),
  TabType.upcoming: const ShiftQuery(
    status: [ShiftStatus.pending],
    myJoinStatus: [ShiftVolunteerStatus.pending, ShiftVolunteerStatus.approved],
    sort: [ShiftQuerySort.startTimeAsc],
  ),
  TabType.completed: const ShiftQuery(
    status: [ShiftStatus.completed],
    myJoinStatus: [
      ShiftVolunteerStatus.approved,
    ],
    sort: [ShiftQuerySort.startTimeDesc],
  ),
  TabType.other: const ShiftQuery(
    status: [ShiftStatus.pending, ShiftStatus.ongoing, ShiftStatus.completed],
    myJoinStatus: [
      ShiftVolunteerStatus.rejected,
      ShiftVolunteerStatus.removed,
      ShiftVolunteerStatus.leaved,
    ],
  ),
};

final myShiftProvider = FutureProvider.autoDispose.family<Shift?, int>(
  (ref, id) => ref.watch(shiftRepositoryProvider).getShiftById(
        id: id,
        query: const ShiftQuery(
          include: [
            ShiftQueryInclude.myShiftVolunteer,
            ShiftQueryInclude.shiftSkill,
            ShiftQueryInclude.activity,
          ],
        ),
      ),
);

final myActivityPagingControllerProvider = Provider.autoDispose((ref) {
  final hasChanged = ref.watch(hasChangedProvider);
  final controller = PagingController<int, Shift>(firstPageKey: 0);
  final searchPattern = ref.watch(searchPatternProvider)?.trim();
  final tabType = ref.watch(tabTypeProvider);
  final selectedStatuses = ref.watch(selectedStatusesProvider);
  final shiftVolunteerRepository = ref.watch(shiftRepositoryProvider);

  controller.addPageRequestListener((pageKey) async {
    try {
      final query = queries[tabType]!;

      final updatedQuery = query.copyWith(
        name: searchPattern?.isNotEmpty == true ? searchPattern : null,
        myJoinStatus: tabType == TabType.upcoming && selectedStatuses.isNotEmpty
            ? selectedStatuses.toList()
            : query.myJoinStatus,
        include: [
          ShiftQueryInclude.myShiftVolunteer,
          ShiftQueryInclude.shiftSkill,
          ShiftQueryInclude.activity,
        ],
        limit: 10,
        offset: pageKey * 10,
      );
      final items = await shiftVolunteerRepository.getShifts(
        query: updatedQuery,
      );
      final isLastPage = items.length < 10;
      if (isLastPage) {
        controller.appendLastPage(items);
      } else {
        controller.appendPage(items, pageKey + 1);
      }
    } catch (err, st) {
      print(st);
      print(err);
      controller.error = err;
    }
  });

  if (hasChanged) {
    controller.notifyPageRequestListeners(0);
  }

  return controller;
});

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
    final res =
        await guardAsyncValue(() => shiftRepository.checkIn(shiftId: shiftId));
    if (!mounted) {
      return;
    }
    ref.invalidate(myActivityPagingControllerProvider);
    ref.invalidate(myShiftProvider);
    ref.read(hasChangedProvider.notifier).state = true;
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
      () => shiftRepository.checkOut(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(myActivityPagingControllerProvider);
    ref.invalidate(myShiftProvider);
    ref.read(hasChangedProvider.notifier).state = true;
    state = res;
  }
}

final checkOutControllerProvider =
    StateNotifierProvider.autoDispose<CheckOutController, AsyncValue<void>>(
  (ref) => CheckOutController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);

class CancelShiftRegistrationController
    extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;

  final ShiftRepository shiftRepository;

  CancelShiftRegistrationController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> cancelShiftRegistration({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.cancelJoinShift(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(myActivityPagingControllerProvider);
    ref.read(hasChangedProvider.notifier).state = true;
    state = res;
  }
}

final cancelShiftRegistrationControllerProvider = StateNotifierProvider
    .autoDispose<CancelShiftRegistrationController, AsyncValue<void>>(
  (ref) => CancelShiftRegistrationController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);

class LeaveShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  LeaveShiftController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> leaveShift({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.leaveShift(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(myActivityPagingControllerProvider);
    ref.read(hasChangedProvider.notifier).state = true;
    state = res;
  }
}

final leaveShiftControllerProvider =
    StateNotifierProvider.autoDispose<LeaveShiftController, AsyncValue<void>>(
  (ref) => LeaveShiftController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
