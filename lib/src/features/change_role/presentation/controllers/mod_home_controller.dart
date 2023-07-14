import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/mod_activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/shift.dart';
import 'package:the_helper/src/features/organization/application/mod_organization_service.dart';

final ongoingActivitiesProvider = FutureProvider.autoDispose((ref) async {
  final orgId = await ref
      .watch(modOrganizationServiceProvider)
      .getCurrentOrganizationId();
  print(orgId);
  final res = await ref
      .watch(modActivityServiceProvider)
      .getActivitiesWithOrganization(organizationId: orgId!);
  // print(res);
  return res;
});

final upcomingActivitiesProvider = FutureProvider.autoDispose((ref) async {
  final orgId = await ref
      .watch(modOrganizationServiceProvider)
      .getCurrentOrganizationId();
  print(orgId);
  final res = await ref
      .watch(modActivityServiceProvider)
      .getActivitiesWithOrganization(organizationId: orgId!);
  for (var i in res) {
    if (i == null) {
      print(i);
    }
  }
  // print(res);
  return res;
});

// final managerShiftProvider = FutureProvider.autoDispose<List<Shift>>((ref) =>
//     ref
//         .watch(modActivityServiceProvider)
//         .getActivitiesWithOrganization(organizationId: organizationId));
