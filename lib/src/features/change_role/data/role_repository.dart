import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/utils/dio.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/flutter_secure_storage_provider.dart';
import 'package:the_helper/src/utils/in_memory_store.dart';

part 'role_repository.g.dart';

const currentRoleKey = 'role.current_role';

//Role Repository class
class RoleRepository {
  final Dio client;
  final String url;
  final _roleState = InMemoryStore<UserRole?>(null);
  final FlutterSecureStorage localStorage;

  RoleRepository({
    required this.client,
    required this.url,
    required this.localStorage,
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

  Future<Role?> setCurrentRole(Role role) async {
    await localStorage.write(key: currentRoleKey, value: role.toString());
    return role;
  }

  Future<void> removeCurrentRole() async {
    await localStorage.write(key: currentRoleKey, value: null);
  }

  Future<Role?> getCurrentRole() async {
    final role = await localStorage.read(key: currentRoleKey);
    if (role == null) {
      await localStorage.write(
          key: currentRoleKey, value: Role.volunteer.toString());
      return null;
    }
    return Role.values.firstWhere((element) => element.toString() == role);
  }
}

final roleProvider = Provider.autoDispose<UserRole?>((ref) {
  final role = ref.watch(roleRepositoryProvider);
  return role._roleState.value;
});

@Riverpod(keepAlive: true)
RoleRepository roleRepository(RoleRepositoryRef ref) {
  return RoleRepository(
    client: ref.watch(dioProvider),
    url: ref.read(baseUrlProvider),
    localStorage: ref.read(secureStorageProvider),
  );
}
// final roleRepositoryProvider = Provider<RoleRepository>((ref) {
//   return RoleRepository(
//     client: ref.read(dioProvider),
//     url: ref.read(baseUrlProvider),
//     localStorage: ref.read(secureStorageProvider),
//   );
// });

// final roleStateChangeProvider = 
