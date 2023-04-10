import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authServiceProvider).valueOrNull?.account;
    final profile = ref.watch(profileServiceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Row(
        children: [
          profile.when(
            data: (profile) => CircleAvatar(
                radius: 24,
                backgroundImage: ImageX.backend(profile.avatarId!).image,
                backgroundColor: Colors.white),
            error: (_, __) => const Text('error'),
            loading: () => const CircleAvatar(
              child: CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profile.when(
                  data: (data) => Text(
                    data.username ?? 'Your profile',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  error: (_, __) => Container(),
                  loading: () => Container(),
                ),
                const SizedBox(height: 8),
                Text(
                  account?.email ?? 'Unknown',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
