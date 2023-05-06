import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/image.dart';

import 'profile_edit_controller.dart';

class ProfileEditAvatarPickerWidget extends ConsumerWidget {
  const ProfileEditAvatarPickerWidget({super.key});

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
        avatarId.when(
          data: (data) => RawMaterialButton(
            onPressed: () async {
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file == null) {
                return;
              }
              ref.read(imageInputControllerProvider.notifier).state = file.path;
              ref
                  .read(profileEditAvatarControllerProvider.notifier)
                  .updateAvatar(file);
            },
            elevation: 2.0,
            fillColor: Colors.transparent,
            padding: EdgeInsets.all(context.mediaQuery.size.width * 0.15),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        )
      ],
    );
  }
}
