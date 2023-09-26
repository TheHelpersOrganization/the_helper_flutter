import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';

import '../../../../activity/application/mod_activity_service.dart';
import '../../../../activity/domain/activity.dart';

part 'organization_activity_controller.g.dart';

@riverpod
Future<List<Activity>> organizationActivityController(
  OrganizationActivityControllerRef ref, {
  int page = 0,
  required int size,
  required int id,
}) async {
  final keepAliveLink = ref.keepAlive();
  Timer(const Duration(minutes: 5), () {
    keepAliveLink.close();
  });
  final ModActivityService service = ref.watch(modActivityServiceProvider);
  final List<Activity> activities = await service.getActivitiesWithOrganization(
      organizationId: id,
      query: ModActivityQuery(
        status: [ActivityStatus.completed],
        limit: size,
        offset: page * size,
      ));
  return activities;
}
