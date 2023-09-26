import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

class VolunteerStatusData {
  final int totalActivity;
  final int increasedActivity;
  final double totalHour;
  final double increasedHour;

  const VolunteerStatusData({
    required this.totalActivity,
    required this.increasedActivity,
    required this.totalHour,
    required this.increasedHour,
  });
}

final suggestedActivitiesProvider = FutureProvider.autoDispose<List<Activity>>(
  (ref) => ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: 5),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

final upcomingActivitiesProvider =
    FutureProvider.autoDispose<List<Activity>>((ref) async {
  final res = await ref.watch(activityServiceProvider).getActivities(
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
      );
  return res;
});

final volunteerShiftProvider = FutureProvider.autoDispose<List<Shift>>(
  (ref) => ref.watch(shiftRepositoryProvider).getShifts(
        query: const ShiftQuery(
          status: [ShiftStatus.pending, ShiftStatus.ongoing],
          myJoinStatus: [
            ShiftVolunteerStatus.approved,
            //ShiftVolunteerStatus.pending
          ],
        ),
      ),
);

final volunteerStatusProvider =
    FutureProvider.autoDispose<VolunteerStatusData>((ref) async {
  final List<Activity> activities =
      await ref.watch(activityServiceProvider).getMyCompletedActivities();
  var timeNow = DateTime.now();
  final timeFilter = DateTime(timeNow.year, timeNow.month);
  final currentActivity =
      activities.filter((t) => t.endTime!.isAfter(timeFilter));
  var totalHour = 0.0;
  var increasedHour = 0.0;

  for (var i in activities) {
    final start = i.startTime!;
    totalHour += (i.endTime!.difference(start).inMinutes) / 60;
  }

  for (var i in currentActivity) {
    final start = i.startTime!;
    increasedHour += (i.endTime!.difference(start).inMinutes) / 60;
  }

  return VolunteerStatusData(
      totalActivity: activities.length,
      increasedActivity: currentActivity.length,
      totalHour: totalHour,
      increasedHour: increasedHour);
});
