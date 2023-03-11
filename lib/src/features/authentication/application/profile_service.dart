// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';
// import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/profile_repository.dart';

// import '../domain/profile.dart';

// class ProfileService {
//   ProfileService({
//     required this.authRepository,
//     required this.profileRepository,
//   });
//   final AuthRepository authRepository;
//   final ProfileRepository profileRepository;
//   Future<Profile?> fetchProfile() async {
//     // final accountToken = await authRepository.autoSignIn();
//     final accountToken = await authRepository.autoSignIn();
//     final profile = profileRepository.fetchProfile(accountToken);
//     return profile;
//   }
// }

// final profileServiceProvider = Provider<ProfileService>((ref) {
//   return ProfileService(
//       authRepository: ref.watch(authRepositoryProvider),
//       profileRepository: ref.watch(profileRepositoryProvider));
// });
