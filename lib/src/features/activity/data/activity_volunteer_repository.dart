import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_volunteer_repository.g.dart';

class ActivityVolunteerRepository {
  final Dio client;

  const ActivityVolunteerRepository({
    required this.client,
  });

  Future<List<ActivityVolunteer>> getActivityVolunteers(
      {required int activityId}) async {
    final List<dynamic> res = (await client.get(
      '/activities/$activityId/volunteers',
    ))
        .data['data'];
    return res.map((e) => ActivityVolunteer.fromJson(e)).toList();
  }
}

@riverpod
ActivityVolunteerRepository activityVolunteerRepository(
    ActivityVolunteerRepositoryRef ref) {
  return ActivityVolunteerRepository(
    client: ref.watch(dioProvider),
  );
}
