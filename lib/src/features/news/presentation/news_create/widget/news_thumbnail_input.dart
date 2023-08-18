import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/image_picker_2/form_builder_image_picker.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class NewsThumbnailInput extends ConsumerWidget {
  final int? initialValue;

  const NewsThumbnailInput({
    super.key,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FormBuilderImagePicker(
        name: 'thumbnail',
        maxImages: 1,
        initialValue:
            initialValue == null ? null : [getImageUrl(initialValue!)],
        previewWidth: context.mediaQuery.size.width,
        previewHeight: context.mediaQuery.size.width / 16 * 9,
        decoration: const InputDecoration.collapsed(
          hintText: 'Pick an image',
        ),
        galleryLabel: const Text('Pick from Gallery'),
        availableImageSources: const [
          ImageSourceOption.gallery,
        ],
        fit: BoxFit.fitWidth,
        onChanged: (value) {
          print('Thumbnail changed');
          ref.read(hasChangeThumbnailProvider.notifier).state = true;
        },
      ),
    );
  }
}
