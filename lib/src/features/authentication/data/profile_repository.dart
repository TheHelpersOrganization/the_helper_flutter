// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../domain/profile.dart';
// import '../domain/token.dart';
// import 'package:simple_auth_flutter_riverpod/src/utils/dio_provider.dart';
// import '../../../utils/domain_provider.dart';

// class ProfileRepository {
//   ProfileRepository({
//     required this.client,
//     required this.url,
//   });
//   final Dio client;
//   final String url;
//   Future<Profile> fetchProfile() async {
//     final response = await client.get('$url/profile/me');
//     print(Profile.fromJson(response.data['data']));
//     return Profile.fromJson(response.data['data']);
//   }
// }

// final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
//   final profile = ProfileRepository(
//     client: ref.read(dioProvider),
//     url: ref.read(baseUrlProvider),
//   );
//   return profile;
// });
