import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/utils/dio.dart';

class ModActivityRepository {
  final Dio client;

  const ModActivityRepository({
    required this.client,
  });

  Future<List<Activity>> getActivities({
    required int organizationId,
    ModActivityQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/mod/organizations/$organizationId/activities/',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Activity.fromJson(e)).toList();
  }

  Future<Activity> createActivity({
    required int organizationId,
    required Activity activity,
  }) async {
    final res = await client.post(
      '/mod/organizations/$organizationId/activities/',
      data: activity.toJson(),
    );
    return Activity.fromJson(res.data['data']);
  }
}

final modActivityRepositoryProvider = Provider<ModActivityRepository>((ref) {
  final client = ref.watch(dioProvider);
  return ModActivityRepository(client: client);
});
