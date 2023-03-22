import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';

import 'edit_profile_controller.dart';

class EditProfileAvatarPickerWidget extends ConsumerWidget {
  const EditProfileAvatarPickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageInputControllerProvider);
    ImageProvider image;
    if (imageUrl == null) {
      image = const NetworkImage(
          'https://avatars.githubusercontent.com/u/66234343?s=400&u=5ceeec60f5b9d0ccc57f73f735ae1a99d2ea4f83&v=4');
    } else if (kIsWeb) {
      image = NetworkImage(imageUrl);
    } else {
      image = FileImage(File(imageUrl));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: context.mediaQuery.size.width * 0.15,
          backgroundImage: image,
        ),
        RawMaterialButton(
          onPressed: () async {
            final picker = ImagePicker();
            final file = await picker.pickImage(source: ImageSource.gallery);
            if (file == null) {
              return;
            }
            ref.read(imageInputControllerProvider.notifier).state = file.path;
          },
          elevation: 2.0,
          fillColor: Colors.transparent,
          padding: EdgeInsets.all(context.mediaQuery.size.width * 0.05),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
