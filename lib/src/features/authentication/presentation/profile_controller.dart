// import 'dart:async';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../data/profile_repository.dart';

// import '../domain/profile.dart';

// part 'profile_controller.g.dart';

// @riverpod
// class ProfileController extends _$ProfileController {
//   @override
//   FutureOr<Profile> build() {
//     return ref.read(profileRepositoryProvider).fetchProfile();
//   }

//   // Future<Profile> getProfile() async {
//   //   final profileRepository = ref.read(profileRepositoryProvider);
//   //   state = const AsyncLoading();
//   //   state = await AsyncValue.guard(() => profileRepository.fetchProfile());
//   // }
// }
