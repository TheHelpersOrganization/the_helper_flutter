import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/dio_provider.dart';

import '../../../common/exception/backend_exception.dart';
import '../../../utils/domain_provider.dart';
import '../domain/profile.dart';

class ProfileRepository {
  ProfileRepository({
    required this.client,
    required this.url,
  });

  final Dio client;
  final String url;

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

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final profile = ProfileRepository(
    client: ref.read(dioProvider),
    url: ref.read(baseUrlProvider),
  );
  return profile;
});
