import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer_query.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import 'activity_volunteer_service.dart';

class ModActivityService {
  final ModActivityRepository modActivityRepository;
  final OrganizationRepository organizationRepository;
  final ActivityVolunteerService activityVolunteerService;

  ModActivityService({
    required this.modActivityRepository,
    required this.organizationRepository,
    required this.activityVolunteerService,
  });

  Future<List<Activity>> getActivitiesWithOrganization({
    required int organizationId,
    ModActivityQuery? query,
  }) async {
    List<Activity> activities = await modActivityRepository.getActivities(
      organizationId: organizationId,
      query: query,
    );
    final organization = await organizationRepository.getById(
      organizationId,
    );
    activities =
        activities.map((e) => e.copyWith(organization: organization)).toList();

    final volunteers = await activityVolunteerService.getActivityVolunteers(
      query: ActivityVolunteerQuery(
        activityId: activities.map((e) => e.id!).toList(),
        include: [
          ActivityVolunteerQueryInclude.profile,
        ],
      ),
    );

    // activities = activities
    //     .mapIndexed((index, element) => element.copyWith(
    //           volunteers:
    //               volunteers.where((v) => v.activityId! == element.id).toList(),
    //         ))
    //     .toList();

    return activities;
  }
}

final modActivityServiceProvider = Provider.autoDispose<ModActivityService>(
  (ref) {
    final modActivityRepository = ref.watch(modActivityRepositoryProvider);
    final organizationRepository = ref.watch(organizationRepositoryProvider);
    final activityVolunteerService =
        ref.watch(activityVolunteerServiceProvider);
    return ModActivityService(
      modActivityRepository: modActivityRepository,
      organizationRepository: organizationRepository,
      activityVolunteerService: activityVolunteerService,
    );
  },
);
