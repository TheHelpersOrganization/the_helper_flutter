import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_volunteer_service.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'activity_service.g.dart';

class ActivityService {
  final Dio client;
  final OrganizationRepository organizationRepository;
  final ActivityRepository activityRepository;
  final ActivityVolunteerService activityVolunteerService;
  final SkillRepository skillRepository;

  const ActivityService({
    required this.client,
    required this.organizationRepository,
    required this.activityRepository,
    required this.activityVolunteerService,
    required this.skillRepository,
  });

  Future<List<Activity>> getSuggestedActivities({
    ActivityQuery? query,
    ActivityInclude? include,
  }) async {
    List<Activity> activities =
        await activityRepository.getActivities(query: query);
    if (include?.organization == true) {
      List<Organization> organizations = await Future.wait(
        activities.map(
          (e) async => await organizationRepository.getById(e.organizationId!),
        ),
      );
      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                organization: organizations[index],
              ))
          .toList();
    }
    if (include?.volunteers == true) {
      List<List<ActivityVolunteer>> activityVolunteers = await Future.wait(
        activities.map(
          (e) async => await activityVolunteerService.getActivityVolunteers(
            activityId: e.id!,
          ),
        ),
      );
      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                volunteers: activityVolunteers[index],
              ))
          .toList();
    }
    return activities;
  }

  Future<List<Activity>> getActivities({
    ActivityQuery? query,
    ActivityInclude? include,
  }) async {
    List<Activity> activities =
        await activityRepository.getActivities(query: query);
    if (include?.organization == true) {
      List<Organization> organizations = await Future.wait(
        activities.map(
          (e) async => await organizationRepository.getById(e.organizationId!),
        ),
      );
      activities = activities
          .mapIndexed((i, a) => a.copyWith(organization: organizations[i]))
          .toList();
    }

    if (include?.volunteers == true) {
      List<List<ActivityVolunteer>> activityVolunteers = await Future.wait(
        activities.map(
          (e) async => await activityVolunteerService.getActivityVolunteers(
            activityId: e.id!,
          ),
        ),
      );

      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                volunteers: activityVolunteers[index],
              ))
          .toList();
    }

    return activities;
  }

  Future<int> getCount({
    ActivityQuery? query,
    ActivityInclude? include,
  }) async {
    List<Activity> activities =
        await activityRepository.getActivities(query: query);

    if (include?.organization == true) {
      List<Organization> organizations = await Future.wait(
        activities.map(
          (e) async => await organizationRepository.getById(e.organizationId!),
        ),
      );
      activities = activities
          .mapIndexed((i, a) => a.copyWith(organization: organizations[i]))
          .toList();
    }

    if (include?.volunteers == true) {
      List<List<ActivityVolunteer>> activityVolunteers = await Future.wait(
        activities.map(
          (e) async => await activityVolunteerService.getActivityVolunteers(
            activityId: e.id!,
          ),
        ),
      );
      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                volunteers: activityVolunteers[index],
              ))
          .toList();
    }

    return activities.length;
  }

  Future<Activity> getActivity({required int activityId}) async {
    final activity = await activityRepository.getActivityById(id: activityId);
    final org = await organizationRepository.getById(activity.organizationId!);

    return activity.copyWith(organization: org);
  }

  Future<Activity?> getActivityById({required int id}) async {
    final activity = await activityRepository.getActivityById(id: id);
    final org = await organizationRepository.getById(activity.organizationId!);
    final skills = await skillRepository.getSkills(
        query: SkillQuery(ids: activity.skillIds));

    return activity.copyWith(skills: skills, organization: org);
  }

  Future<List<Activity>> getMyCompletedActivities() async {
    final activity = await activityRepository.getMyCompletedActivities();
    return activity;
  }
}

@riverpod
ActivityService activityService(ActivityServiceRef ref) {
  return ActivityService(
    client: ref.watch(dioProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
    activityRepository: ref.watch(activityRepositoryProvider),
    activityVolunteerService: ref.watch(activityVolunteerServiceProvider),
    skillRepository: ref.watch(skillRepositoryProvider),
  );
}
