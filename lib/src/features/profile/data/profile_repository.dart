import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../../../utils/domain_provider.dart';
import '../../account/domain/account_verification.dart';
import '../domain/profile.dart';
import '../domain/profile_setting_options.dart';
import '../domain/verified_request.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository({
    required this.client,
    required this.url,
  });
  final Dio client;
  final String url;

  Future<List<Profile>> getProfiles(GetProfilesData data) async {
    final List<dynamic> res = (await client.get(
      '/profiles',
      data: data.toJson(),
    ))
        .data['data'];
    return res.map((e) => Profile.fromJson(e)).toList();
  }

  // TODO: this method should be rename as get your profile
  Future<Profile> getProfile({
    // Map<String, dynamic>? queryParameters,
    int? id,
  }) async {
    final response = await client.get(
      '/profiles/me?includes=interested-skills,skills',
      // (id != null) ? '/profiles/me' : '/profiles/$id',
      // queryParameters: queryParameters,
    );
    return Profile.fromJson(response.data['data']);
  }

  Future<Profile> getBriefProfile({
    required int id,
    List<String>? includes,
    List<String>? select,
  }) async {
    final res = (await client.get('/profiles',
            queryParameters: {
              'ids': id,
              'includes': includes?.join(','),
              'select': select?.join(','),
            }..removeWhere((key, value) => value == null)))
        .data['data'][0];
    // print(res);
    return Profile.fromJson(res);
  }

  Future<Profile> getProfileById(int id) async {
    final response = await client.get(
      '/profiles/$id',
    );
    return Profile.fromJson(response.data['data']);
  }

  // TODO: this method should be rename as update your profile
  Future<Profile> updateProfile(Profile profile) async {
    final response = await client.put(
      '/profiles/me',
      data: profile.toJson(),
    );
    return Profile.fromJson(response.data['data']);
  }

  Future<AccountVerificationModel> requestVerifiedProfile(
      VerifiedRequestBody request) async {
    final response = await client.post(
      '/account-verifications',
      data: request.toJson(),
    );
    return AccountVerificationModel.fromJson(response.data['data']);
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) =>
    ProfileRepository(
      client: ref.watch(dioProvider),
      url: ref.read(baseUrlProvider),
    );
// @Riverpod(keepAlive: true)
@riverpod
Future<Profile> profile(ProfileRef ref) =>
    ref.watch(profileRepositoryProvider).getProfile();

// @riverpod
// Future<Profile> updateProfile(UpdateProfileRef ref, {required Profile profile}) {
// ref.read(profileRepositoryProvider).updateProfile(profile);
// return ref.watch(profileProvider.future);
// }
// final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
//   final profile = ProfileRepository(
//     client: ref.watch(dioProvider),
//     url: ref.read(baseUrlProvider),
//   );
//   return profile;
// });

@Riverpod(keepAlive: true)
// @riverpod
class ProfileSettingOptionList extends _$ProfileSettingOptionList {
  @override
  List<ProfileSettingOption> build() {
    // Todo: User profile settings must save in the database for hide/show information to anyone else
    return [
      ProfileSettingOption(label: 'Show Overview tab', optionState: true),
      ProfileSettingOption(label: 'Show Activity tab', optionState: true),
      ProfileSettingOption(label: 'Show Organization tab', optionState: true),
      ProfileSettingOption(
          label: 'Show Detail tab', optionState: true, isDisable: true),
      ProfileSettingOption(
          label: 'Show Organization roles', optionState: false, isTab: false),
    ];
  }

  void toggle(String tabLabel) {
    state = [
      for (final option in state)
        if (option.label == tabLabel)
          option.copyWith(optionState: !option.optionState)
        else
          option,
    ];
  }
}

@riverpod
List<Object?> profileTabs(ProfileTabsRef ref) {
  final options = ref.read(profileSettingOptionListProvider);
  return [
    for (final option in options)
      if (option.isTab && !option.isDisable) option
  ];
}
