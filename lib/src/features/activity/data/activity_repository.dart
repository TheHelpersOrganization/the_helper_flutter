import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_repository.g.dart';

class ActivityRepository {
  final Dio client;
  final OrganizationRepository organizationRepository;

  const ActivityRepository({
    required this.client,
    required this.organizationRepository,
  });

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

  Future<Activity?> updateActivity({
    required int id,
    required Activity activity,
  }) async {
    final res = await client.put(
      '/activities/$id',
      data: activity.toJson(),
    );
    return Activity.fromJson(res.data['data']);
  }

  Future<Activity?> deleteActivity({
    required int id,
  }) async {
    final res = await client.delete(
      '/activities/$id',
    );
    return Activity.fromJson(res.data['data']);
  }
}

@riverpod
ActivityRepository activityRepository(ActivityRepositoryRef ref) {
  return ActivityRepository(
    client: ref.watch(dioProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
  );
}
