import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

part 'role_controller.g.dart';

final getRoleProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(roleRepositoryProvider).getCurrentRole(),
);

@Riverpod(keepAlive: true)
class RoleController extends _$RoleController {
  @override
  FutureOr<Role?> build() async {
    return await (ref.watch(roleRepositoryProvider).getCurrentRole());
  }

  Future<void> setCurrentRole(Role role) async {
    print('Set role: $role');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(roleRepositoryProvider).setCurrentRole(
            role,
          ),
    );
  }
}

@riverpod
Future<List<Role>> getAllRoles(GetAllRolesRef ref) async {
  final accountToken = await ref.watch(authServiceProvider.future);
  return accountToken!.account.roles;
}
