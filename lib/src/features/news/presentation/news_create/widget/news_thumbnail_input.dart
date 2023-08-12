import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/image_picker_2/form_builder_image_picker.dart';

class NewsThumbnailInput extends StatelessWidget {
  const NewsThumbnailInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FormBuilderImagePicker(
        name: 'thumbnail',
        maxImages: 1,
        //maxWidth: context.mediaQuery.size.width,
        //maxHeight: 240,
        previewWidth: context.mediaQuery.size.width,
        previewHeight: context.mediaQuery.size.width / 16 * 9,
        decoration: const InputDecoration.collapsed(
          hintText: 'Pick an image',
        ),
        galleryLabel: const Text('Pick from Gallery'),
        // availableImageSources: const [
        //   ImageSourceOption.gallery,
        // ],
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
