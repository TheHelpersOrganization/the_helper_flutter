import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/activity_volunteer_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
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

  Future<List<ActivityVolunteer>> getActivityVolunteers(
      {required int activityId}) async {
    List<ActivityVolunteer> activityVolunteers =
        await activityVolunteerRepository.getActivityVolunteers(
            activityId: activityId);
    List<Profile> profiles = await Future.wait(
      activityVolunteers.map(
        (e) async => await profileRepository.getProfileById(
          e.accountId,
        ),
      ),
    );

    List<ActivityVolunteer> res = [];
    for (int i = 0; i < activityVolunteers.length; i++) {
      res.add(activityVolunteers[i].copyWith(profile: profiles[i]));
    }
    return res;
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
