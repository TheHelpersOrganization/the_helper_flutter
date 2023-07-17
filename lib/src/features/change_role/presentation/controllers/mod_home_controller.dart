import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/mod_activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/organization/application/mod_organization_service.dart';
import 'package:the_helper/src/features/shift/application/mod_shift_volunteer_service.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';

final ongoingActivitiesProvider = FutureProvider.autoDispose<List<Activity>>((ref) async {
  final orgId = await ref
      .watch(modOrganizationServiceProvider)
      .getCurrentOrganizationId();
  return ref
      .watch(modActivityServiceProvider)
      .getActivitiesWithOrganization(
        organizationId: orgId!,
        query: ModActivityQuery(
          limit: 5,
          status: [ActivityStatus.ongoing]
        )
    );
});

final upcomingActivitiesProvider = FutureProvider.autoDispose<List<Activity>>((ref) async {
  final orgId = await ref
      .watch(modOrganizationServiceProvider)
      .getCurrentOrganizationId();
  return ref
      .watch(modActivityServiceProvider)
      .getActivitiesWithOrganization(
        organizationId: orgId!,
        query: ModActivityQuery(
          limit: 5,
          startTime: [
            DateTime.now(),
            DateTime.now().add(const Duration(days: 7))
          ]
        ),
      );
});

final managerShiftProvider = FutureProvider.autoDispose<List<Shift>>((ref) =>
    ref
        .watch(modShiftVolunteerServiceProvider)
        .getShifts(
          query: const ShiftQuery(
            status: [ShiftStatus.pending, ShiftStatus.ongoing],
            isShiftManager: true,
          )
        ));
