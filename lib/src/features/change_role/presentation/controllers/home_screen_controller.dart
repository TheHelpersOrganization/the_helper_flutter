import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

class HomeScreenController extends StateNotifier<UserRole> {
  HomeScreenController({required this.roleRepository})
      : super(const UserRole(isMod: true, isAdmin: true, role: 0));
  final UserRole? roleRepository;

  Future<void> changeRole(int role) async {
    //print(role);
    state = UserRole(
      isMod: roleRepository?.isMod ?? false,
      isAdmin: roleRepository?.isAdmin ?? false,
      role: role,
    );
  }
}

final homeScreenControllerProvider =
    StateNotifierProvider<HomeScreenController, UserRole>((ref) {
  return HomeScreenController(
      roleRepository: ref.watch(roleRepositoryProvider));
});
