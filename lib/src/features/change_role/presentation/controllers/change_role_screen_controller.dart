import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

class ChangeRoleScreenController extends StateNotifier<UserRole> {
  ChangeRoleScreenController({required this.roleRepository})
      : super(const UserRole(isMod: true, isAdmin: true, role: 0));
  final UserRole? roleRepository;
}

final changeRoleScreenControllerProvider =
    StateNotifierProvider.autoDispose<ChangeRoleScreenController, UserRole>(
        (ref) {
  return ChangeRoleScreenController(roleRepository: ref.watch(roleProvider));
});
