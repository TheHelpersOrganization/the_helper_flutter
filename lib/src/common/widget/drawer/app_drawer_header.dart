import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authServiceProvider).valueOrNull?.account;
    // final avatarId = ref.watch(profileProvider.select((profile) => profile.avatarId));
    // final avatarId = ref.watch(profileServiceProvider).valueOrNull?.avatarId;
    final profile = ref.watch(profileServiceProvider);
    // final image = avatarId == null
    //     ? Image.asset('assets/images/organization_placeholder.jpg')
    //     : ImageX.backend(avatarId);
    // final image = profile.when(
    //   data: (profile) => ImageX.backend(profile.avatarId!),
    //   error: (_, __) =>
    //       Image.asset('assets/images/organization_placeholder.jpg'),
    //   loading: () => const CircularProgressIndicator(),
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Row(
        children: [
          // CircleAvatar(
          //   radius: 24,
          //   backgroundImage: image.image,
          //   backgroundColor: Colors.white,
          // ),
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
                const Text(
                  'Volunteer Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
