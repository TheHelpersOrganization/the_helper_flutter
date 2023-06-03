import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/profile_repository.dart';
import '../domain/profile.dart';

part 'profile_controller.g.dart';

// TODO: resolve conflict betweeen keepAlive and autoDispose
// @Riverpod(keepAlive: true)
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<Profile> build() async {
    return _fetchProfile();
  }

  Future<Profile> _fetchProfile() async {
    final repository = ref.watch(profileRepositoryProvider);
    final profile = await repository.getProfile();
    return profile;
  }

  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final profileRepository = ref.read(profileRepositoryProvider);
      await profileRepository.updateProfile(profile);
      return _fetchProfile();
    });
  }
}
