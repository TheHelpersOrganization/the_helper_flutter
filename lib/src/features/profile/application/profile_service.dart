import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_query.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';

import '../domain/profile.dart';

part 'profile_service.g.dart';

class ProfileService {
  final ProfileRepository profileRepository;
  final OrganizationRepository organizationRepository;
  final ActivityRepository activityRepository;
  ProfileService({
    required this.profileRepository,
    required this.organizationRepository,
    required this.activityRepository,
  });

  Future<List<Organization>> getJoinedOrganizations() async {
    // TODO: add logic to check is this your profile or another one profile
    return await organizationRepository.get(
      query: const OrganizationQuery(joined: true),
    );
  }

  Future<List<Activity>> getJoinedAndCompletedActivity() async {
    // TODO: add logic to check is this your profile or another one profile
    return await activityRepository.getActivitiesQ(
      // TODO: Complete this function
      queryParameters: {
        'status': 'completed',
        'joinedStatus': 'approved',
      },
    );
  }
}

@riverpod
ProfileService profileService(ProfileServiceRef ref) {
  return ProfileService(
    profileRepository: ref.watch(profileRepositoryProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
    activityRepository: ref.watch(activityRepositoryProvider),
  );
}

@riverpod
class AccountProfileService extends _$AccountProfileService {
  @override
  FutureOr<Profile> build({
    required int id
  }) async {
    return _fetchProfile(id: id);
  }

  Future<Profile> _fetchProfile({
    required int id,
  }) async {
    final repository = ref.watch(profileRepositoryProvider);
    final profile = await repository.getProfileById(id);
    return profile;
  }
}
