import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/activity_volunteer_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer_query.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_volunteer_service.g.dart';

class ActivityVolunteerService {
  final Dio client;
  final ActivityVolunteerRepository activityVolunteerRepository;
  final ProfileRepository profileRepository;

  const ActivityVolunteerService({
    required this.client,
    required this.activityVolunteerRepository,
    required this.profileRepository,
  });

  Future<List<ShiftVolunteer>> getActivityVolunteers({
    ActivityVolunteerQuery? query,
  }) async {
    List<ShiftVolunteer> activityVolunteers =
        await activityVolunteerRepository.getActivityVolunteers(query: query);
    return activityVolunteers;
  }
}

@riverpod
ActivityVolunteerService activityVolunteerService(
    ActivityVolunteerServiceRef ref) {
  return ActivityVolunteerService(
    client: ref.watch(dioProvider),
    activityVolunteerRepository: ref.watch(activityVolunteerRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  );
}
