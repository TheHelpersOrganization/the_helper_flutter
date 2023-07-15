import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/domain/update_activity.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/activity_log_query.dart';

part 'activity_repository.g.dart';

class ActivityRepository {
  final Dio client;
  final OrganizationRepository organizationRepository;

  const ActivityRepository({
    required this.client,
    required this.organizationRepository,
  });
  //TODO: Choose only 1 between 2 approachs below
  Future<List<Activity>> getActivitiesQ(
      {Map<String, dynamic>? queryParameters}) async {
    final List<dynamic> res =
        (await client.get('/activities', queryParameters: queryParameters))
            .data['data'];
    return res.map((data) => Activity.fromJson(data)).toList();
  }

  Future<List<Activity>> getActivities({ActivityQuery? query}) async {
    final List<dynamic> res = (await client.get(
      '/activities',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Activity.fromJson(e)).toList();
  }

  Future<List<Activity>> getSuggestedActivities({ActivityQuery? query}) async {
    List<Activity> activities = await getActivities(query: query);
    return activities;
  }

  Future<Activity> getActivityById(
      {required int id, ActivityQuery? query, turn}) async {
    final res = await client.get(
      '/activities/$id',
      queryParameters: query?.toJson(),
    );
    return Activity.fromJson(res.data['data']);
  }

  Future<List<Activity>> getMyCompletedActivities() async {
    final List<dynamic> res = (await client.get(
      '/activities',
      queryParameters: {
        'status': 'completed',
        'joinStatus': 'approved',
      },
    ))
        .data['data'];
    return res.map((e) => Activity.fromJson(e)).toList();
  }

  Future<Activity?> updateActivity({
    required int activityId,
    required UpdateActivity activity,
  }) async {
    final res = await client.put(
      '/activities/$activityId',
      data: activity.toJson(),
    );
    return Activity.fromJson(res.data['data']);
  }

  Future<Activity?> deleteActivity({
    required int activityId,
  }) async {
    final res = await client.delete(
      '/activities/$activityId',
    );
    return Activity.fromJson(res.data['data']);
  }

  Future<ActivityLog> getLog({
    ActivityLogQuery? query,
  }) async {
    final res =
        await client.get('/activities/count', queryParameters: query?.toJson());
    return ActivityLog.fromJson(res.data['data']);
  }
}

@riverpod
ActivityRepository activityRepository(ActivityRepositoryRef ref) {
  return ActivityRepository(
    client: ref.watch(dioProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
  );
}
