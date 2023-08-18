import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

class RoleService extends AsyncNotifier<Role> {
  late RoleRepository _roleRepository;

  @override
  FutureOr<Role> build() async {
    _roleRepository = ref.watch(roleRepositoryProvider);
    return _roleRepository.getCurrentRole();
  }

  Future<Role> setCurrentRole(Role role) async {
    
    final res = await _roleRepository.setCurrentRole(role);
    state = AsyncValue.data(role);
    return res;
  }

  Future<void> removeCurrentRole() async {
    await _roleRepository.removeCurrentRole();
    state = const AsyncValue.data(Role.volunteer);
  }

  Future<Role> getCurrentRole() async {
    return _roleRepository.getCurrentRole();
  }
}

final roleServiceProvider = AsyncNotifierProvider<RoleService, Role>(() {
  return RoleService();
});
