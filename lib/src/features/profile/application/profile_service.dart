import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/profile_repository.dart';
import '../domain/profile.dart';

part 'profile_service.g.dart';

@riverpod
class ProfileService extends _$ProfileService {
  @override
  FutureOr<Profile> build() async {
    final profile = ref.watch(profileProvider.future);
    return profile;
    // return _fetchProfile();
  }

  // Future<Profile> _fetchProfile() async {
  //   // final profileRepository = ref.watch(profileRepositoryProvider);

  // }
}
