import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/activity/my_activity/screen/my_activity_screen.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/utils/async_value.dart';

final isSearchingProvider = StateProvider.autoDispose((ref) => false);
final hasChangedProvider = StateProvider.autoDispose((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final tabTypeProvider = StateProvider.autoDispose((ref) => TabType.ongoing);

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
    myJoinStatus: [ShiftVolunteerStatus.approved],
    sort: [ShiftQuerySort.startTimeDesc],
  ),
  TabType.other: const ShiftQuery(
    status: [ShiftStatus.ongoing],
  ),
};

final myActivityPagingControllerProvider = Provider.autoDispose((ref) {
  final hasChanged = ref.watch(hasChangedProvider);
  final controller = PagingController<int, Shift>(firstPageKey: 0);
  final searchPattern = ref.watch(searchPatternProvider)?.trim();
  final status = ref.watch(tabTypeProvider);
  final shiftVolunteerRepository = ref.watch(shiftRepositoryProvider);

  controller.addPageRequestListener((pageKey) async {
    try {
      final query = queries[status]!;
      final updatedQuery = query.copyWith(
        name: searchPattern?.isNotEmpty == true ? searchPattern : null,
        include: [
          ShiftQueryInclude.myShiftVolunteer,
          ShiftQueryInclude.shiftSkill,
          ShiftQueryInclude.activity,
        ],
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
    } catch (err) {
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
    state = const AsyncValue.loading();
    final res =
        await guardAsyncValue(() => shiftRepository.checkIn(shiftId: shiftId));
    if (!mounted) {
      return;
    }
    ref.invalidate(myActivityPagingControllerProvider);
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
  final ShiftRepository shiftRepository;

  CheckOutController({
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> checkOut({required int shiftId}) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.checkOut(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    state = res;
  }
}

final checkOutControllerProvider =
    StateNotifierProvider.autoDispose<CheckOutController, AsyncValue<void>>(
  (ref) => CheckOutController(
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
