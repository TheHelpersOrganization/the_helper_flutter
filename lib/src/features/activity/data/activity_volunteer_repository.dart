import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_volunteer_repository.g.dart';

class ActivityVolunteerRepository {
  final Dio client;

  const ActivityVolunteerRepository({
    required this.client,
  });

  Future<List<ShiftVolunteer>> getActivityVolunteers(
      {ActivityVolunteerQuery? query}) async {
    final List<dynamic> res = (await client.get(
      '/activity-volunteers',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => ShiftVolunteer.fromJson(e)).toList();
  }
}

@riverpod
ActivityVolunteerRepository activityVolunteerRepository(
    ActivityVolunteerRepositoryRef ref) {
  return ActivityVolunteerRepository(
    client: ref.watch(dioProvider),
  );
}
