import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

class ModActivityService {
  final ModActivityRepository modActivityRepository;
  final OrganizationRepository organizationRepository;

  ModActivityService({
    required this.modActivityRepository,
    required this.organizationRepository,
  });

  Future<List<Activity>> getActivitiesWithOrganization({
    required int organizationId,
    ModActivityQuery? query,
  }) async {
    final activities = await modActivityRepository.getActivities(
      organizationId: organizationId,
      query: query,
    );
    final organization = await organizationRepository.getById(
      organizationId,
    );
    return activities
        .map((e) => e.copyWith(organization: organization))
        .toList();
  }
}

final modActivityServiceProvider = Provider.autoDispose<ModActivityService>(
  (ref) {
    final modActivityRepository = ref.watch(modActivityRepositoryProvider);
    final organizationRepository = ref.watch(organizationRepositoryProvider);
    return ModActivityService(
      modActivityRepository: modActivityRepository,
      organizationRepository: organizationRepository,
    );
  },
);
