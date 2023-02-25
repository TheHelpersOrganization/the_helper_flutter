import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/logout_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/profile_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/async_value_ui.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      logoutControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final state = ref.watch(logoutControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading
            ? const CircularProgressIndicator()
            : const Text('Profile'),
        actions: [
          TextButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    ref.read(logoutControllerProvider.notifier).signOut();
                  },
            child: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      // body: const ProfileWidget(),
    );
  }
}
