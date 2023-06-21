import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/profile_repository.dart';
import '../domain/profile.dart';

part 'profile_controller.g.dart';

// TODO: resolve conflict betweeen keepAlive and autoDispose
// @Riverpod(keepAlive: true)
@riverpod
class ProfileController extends _$ProfileController {
  // '/profiles/me?includes=interested-skills,skills',
  @override
  FutureOr<Profile> build() async {
    return _getProfile();
  }

  Future<Profile> _getProfile() async {
    final repository = ref.watch(profileRepositoryProvider);
    final profile = await repository.getProfile(
      // queryParameters: {
        // 'includes': 'interested-skills,skills',
      // },
    );
    return profile;
  }

  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final profileRepository = ref.read(profileRepositoryProvider);
      await profileRepository.updateProfile(profile);
      return _getProfile();
    });
  }
}
