import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/application/role_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/router/router.dart';

class SetRoleController extends AutoDisposeAsyncNotifier<Role?> {
  @override
  FutureOr<Role?> build() async {
    return ref.read(roleServiceProvider.notifier).getCurrentRole();
  }

  Future<void> setCurrentRole(Role role, {bool navigateToHome = false}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(
      () => ref.read(roleServiceProvider.notifier).setCurrentRole(
            role,
          ),
    );
    if (navigateToHome) {
      ref.read(routerProvider).goNamed(AppRoute.home.name);
      return;
    }
    state = newState;
  }
}

final setRoleControllerProvider =
    AutoDisposeAsyncNotifierProvider<SetRoleController, Role?>(() {
  return SetRoleController();
});

final getAccountRolesProvider =
    FutureProvider.autoDispose<List<Role>>((ref) async {
  final accountToken = await ref.watch(authServiceProvider.future);
  return accountToken!.account.roles;
});
