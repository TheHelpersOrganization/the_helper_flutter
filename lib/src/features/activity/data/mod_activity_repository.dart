import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/utils/dio.dart';

class ModActivityRepository {
  final Dio client;

  const ModActivityRepository({
    required this.client,
  });

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
