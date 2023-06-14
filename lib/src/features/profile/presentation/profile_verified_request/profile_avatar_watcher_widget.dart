import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/image.dart';

import '../profile_edit/profile_edit_controller.dart';

class ProfileAvatarWatcherWidget extends ConsumerWidget {
  const ProfileAvatarWatcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarId = ref.watch(profileEditAvatarControllerProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        avatarId.when(
          data: (data) => CircleAvatar(
            radius: context.mediaQuery.size.width * 0.15,
            backgroundColor: Colors.white,
            backgroundImage: data == null
                ? null
                : ImageX.backend(
                    data,
                  ).image,
          ),
          error: (_, __) => CircleAvatar(
            radius: context.mediaQuery.size.width * 0.15,
          ),
          loading: () => CircleAvatar(
            radius: context.mediaQuery.size.width * 0.15,
          ),
        ),
      ],
    );
  }
}
