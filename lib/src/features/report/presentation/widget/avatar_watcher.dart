import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/image.dart';

class AvatarWatcherWidget extends ConsumerWidget {
  final int? avatarId;
  final double? radius;
  const AvatarWatcherWidget({super.key, this.avatarId, this.radius});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: radius ?? context.mediaQuery.size.width * 0.05,
          backgroundColor: Colors.white,
          backgroundImage: avatarId == null
              ? null
              : ImageX.backend(
                  avatarId!,
                ).image,
        )
      ],
    );
  }
}
