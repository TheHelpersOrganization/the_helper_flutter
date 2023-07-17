import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

final suggestedActivitiesProvider = FutureProvider.autoDispose<List<Activity>>(
  (ref) => ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: 5),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

final upcomingActivitiesProvider = FutureProvider.autoDispose<List<Activity>>(
  (ref) => ref.watch(activityServiceProvider).getActivities(
        query: ActivityQuery(
          limit: 5,
          startTime: [
            DateTime.now(),
            DateTime.now().add(const Duration(days: 7))
          ],
        ),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

final volunteerShiftProvider = FutureProvider.autoDispose<List<Shift>>(
  (ref) => ref.watch(shiftRepositoryProvider).getShifts(
        query: const ShiftQuery(
          status: [ShiftStatus.pending, ShiftStatus.ongoing],
          myJoinStatus: [
            ShiftVolunteerStatus.approved,
            ShiftVolunteerStatus.pending
          ],
        ),
      ),
);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityService = ref.watch(activityServiceProvider);
    final controller = PagingController<int, Activity>(firstPageKey: 0);

    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityService.getActivities(
          query: ActivityQuery(
            limit: 5,
            offset: pageKey,
          ),
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    return controller;
  },
);
