import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/features/activity/application/activity_volunteer_service.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_query.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/activity_log_query.dart';

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
        await activityRepository.getSuggestedActivities(query: query);
    if (include?.organization == true) {
      List<int> orgIds = activities.map((e) => e.organizationId!).toList();
      List<Organization> organizations = await organizationRepository.getAll(
        query: OrganizationQuery(
          id: orgIds,
        ),
      );
      activities = activities
          .mapIndexed((index, activity) => activity.copyWith(
                organization: organizations.firstWhere(
                  (org) => org.id == activity.organizationId,
                ),
              ))
          .toList();
    }
    if (include?.volunteers == true) {
      final volunteers = await activityVolunteerService.getActivityVolunteers(
        query: ActivityVolunteerQuery(
          activityId: activities.map((e) => e.id!).toList(),
          include: [
            ActivityVolunteerQueryInclude.profile,
          ],
          limitPerActivity: 7,
        ),
      );

      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                volunteers: volunteers
                    .where((v) => v.activityId! == element.id)
                    .toList(),
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
      List<int> orgIds = activities.map((e) => e.organizationId!).toList();
      List<Organization> organizations = await organizationRepository.getAll(
        query: OrganizationQuery(
          id: orgIds,
        ),
      );
      activities = activities
          .mapIndexed((index, activity) => activity.copyWith(
                organization: organizations.firstWhere(
                  (org) => org.id == activity.organizationId,
                ),
              ))
          .toList();
    }

    if (include?.volunteers == true) {
      final volunteers = await activityVolunteerService.getActivityVolunteers(
        query: ActivityVolunteerQuery(
          activityId: activities.map((e) => e.id!).toList(),
          limitPerActivity: 7,
          include: [
            ActivityVolunteerQueryInclude.profile,
          ],
        ),
      );

      activities = activities
          .mapIndexed((index, element) => element.copyWith(
                volunteers: volunteers
                    .where((v) => v.activityId! == element.id)
                    .toList(),
              ))
          .toList();
    }

    return activities;
  }

  Future<DataLog> getLog({
    ActivityLogQuery? query,
  }) async {
    DataLog log = await activityRepository.getLog(query: query);

    return log;
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
