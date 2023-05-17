import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_volunteer_service.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_service.g.dart';

class ActivityService {
  final Dio client;
  final OrganizationRepository organizationRepository;
  final ActivityRepository activityRepository;
  final ActivityVolunteerService activityVolunteerService;

  const ActivityService({
    required this.client,
    required this.organizationRepository,
    required this.activityRepository,
    required this.activityVolunteerService,
  });

  Future<List<Activity>> getSuggestedActivities({ActivityQuery? query}) async {
    List<Activity> activities =
        await activityRepository.getActivities(query: query);
    List<Organization> organizations = await Future.wait(
      activities.map(
        (e) async => await organizationRepository.getById(e.organizationId!),
      ),
    );

    List<Activity> res = [];
    for (int i = 0; i < activities.length; i++) {
      List<ActivityVolunteer> activityVolunteers =
          await activityVolunteerService.getActivityVolunteers(
        activityId: activities[i].id!,
      );

      res.add(activities[i].copyWith(
          organization: organizations[i], volunteers: activityVolunteers));
    }
    return res;
  }

  Future<List<Activity>> getActivities({ActivityQuery? query}) async {
    List<Activity> activities =
        await activityRepository.getActivities(query: query);
    List<Organization> organizations = await Future.wait(
      activities.map(
        (e) async => await organizationRepository.getById(e.organizationId!),
      ),
    );

    List<Activity> res = [];
    for (int i = 0; i < activities.length; i++) {
      res.add(activities[i].copyWith(organization: organizations[i]));
    }
    return res;
  }

  Future<Activity> getActivity({required int activityId}) async {
    final activity = await activityRepository.getActivityById(id: activityId);
    final org = await organizationRepository.getById(activity.organizationId!);

    return activity.copyWith(organization: org);
  }
}

@riverpod
ActivityService activityService(ActivityServiceRef ref) {
  return ActivityService(
    client: ref.watch(dioProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
    activityRepository: ref.watch(activityRepositoryProvider),
    activityVolunteerService: ref.watch(activityVolunteerServiceProvider),
  );
}
