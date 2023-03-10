import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/profile_service.dart';
import '../data/profile_repository.dart';

import '../domain/profile.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  Future<Profile> _fetchProfile() async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    final profile = await profileRepository.getProfile();
    return profile;
  }

  @override
  FutureOr<Profile> build() {
    return _fetchProfile();
  }

  Future<void> updateProfile(Profile profile) async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await profileRepository.updateProfile(profile);
        return _fetchProfile();
      },
    );
  }

  // Future<void> getProfile() async {
  //   final profileService = ref.watch(profileServiceProvider);
  //   state = const AsyncLoading();
  //   state = await AsyncValue.guard(profileService.fetchProfile);
  // }
}
