import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';

class AppDrawerUser extends ConsumerWidget {
  const AppDrawerUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authServiceProvider).valueOrNull?.account;
    final profile = ref.watch(profileControllerProvider());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          profile.when(
            data: (profile) => CircleAvatar(
                radius: 24,
                backgroundImage: profile.avatarId == null
                    ? Image.asset('assets/images/logo.png').image
                    : ImageX.backend(
                        profile.avatarId!,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                      ).image,
                backgroundColor: Colors.white),
            error: (_, __) => const Text('error'),
            loading: () => const CircleAvatar(
              radius: 24,
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profile.when(
                    data: (data) => Text(
                      data.username ?? 'Your profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: context.theme.textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    error: (_, __) => Container(),
                    loading: () => Container(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    account?.email ?? 'Unknown',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
