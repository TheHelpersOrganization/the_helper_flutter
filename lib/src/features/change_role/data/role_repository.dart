import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:simple_auth_flutter_riverpod/src/features/change_role/domain/user_role.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/dio_provider.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/domain_provider.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/in_memory_store.dart';

//Role Repository class
class RoleRepository {
  final Dio client;
  final String url;
  final _roleState = InMemoryStore<UserRole?>(null);

  RoleRepository({
    required this.client,
    required this.url,
  });

  Future<void> getUserRole(String userID) async {
    final response = await client.get(
      '$url/somthing',
      data: {
        'id': userID,
      },
    );
    _roleState.value = UserRole.fromJson(response.data['data']);
  }
}

final roleRepositoryProvider = Provider<UserRole?>((ref) {
  final role = RoleRepository(
    client: ref.read(dioProvider),
    url: ref.read(baseUrlProvider),
  );
  return role._roleState.value;
});

// final roleStateChangeProvider = 
