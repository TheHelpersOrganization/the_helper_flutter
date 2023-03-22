import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/utils/dio_provider.dart';

import '../../../common/exception/backend_exception.dart';
import '../../../utils/domain_provider.dart';
import '../domain/profile.dart';
import '../domain/profile_setting_options.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository({
    required this.client,
    required this.url,
  });
  final Dio client;
  final String url;

  // TODO: this method should be rename as get your profile
  Future<Profile> getProfile() async {
    try {
      final response = await client.get(
        '$url/profiles/me',
      );
      return Profile.fromJson(response.data['data']);
    } on DioError catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }
  // TODO: get another user profile
  // Future<Profile> getProfile(UserID uid) async {}

  // TODO: this method should be rename as update your profile
  Future<Profile> updateProfile(Profile profile) async {
    try {
      final response = await client.put(
        '$url/profiles/me',
        data: profile.toJson(),
      );
      return Profile.fromJson(response.data['data']);
    } on DioError catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) =>
    ProfileRepository(
      client: ref.watch(dioProvider),
      url: ref.read(baseUrlProvider),
    );
@riverpod
Future<Profile> profile(ProfileRef ref) =>
    ref.read(profileRepositoryProvider).getProfile();

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
