import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/router/router.dart';

part 'role_controller.g.dart';

final getRoleProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(roleRepositoryProvider).getCurrentRole(),
);

@riverpod
class SetRoleController extends _$SetRoleController {
  Object? _key; // 1. create a key

  @override
  FutureOr<Role?> build() async {
    _key = Object(); // 2. initialize it
    ref.onDispose(() => _key = null); // 3. set to null on dispose
    return ref.watch(roleRepositoryProvider).getCurrentRole();
  }

  Future<void> setCurrentRole(Role role, {bool navigateToHome = false}) async {
    state = const AsyncLoading();
    final key = _key;
    final newState = await AsyncValue.guard(
      () => ref.read(roleRepositoryProvider).setCurrentRole(
            role,
          ),
    );
    if (key == _key) {
      // 5. check if the key is still the same
      if (navigateToHome) {
        ref.read(routerProvider).goNamed(AppRoute.home.name);
        return;
      }
      state = newState;
    }
  }
}

@riverpod
Future<List<Role>> getAllRoles(GetAllRolesRef ref) async {
  final accountToken = await ref.watch(authServiceProvider.future);
  return accountToken!.account.roles;
}
