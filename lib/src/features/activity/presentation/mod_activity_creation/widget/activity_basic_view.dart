import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/image_picker_2/form_builder_image_picker.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class ActivityBasicView extends ConsumerWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Activity? initialActivity;

  const ActivityBasicView({
    super.key,
    required this.formKey,
    this.initialActivity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thumbnail',
                style: context.theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              FormBuilderImagePicker(
                name: 'thumbnail',
                initialValue: initialActivity?.thumbnail == null
                    ? null
                    : [getImageUrl(initialActivity!.thumbnail!)],
                maxImages: 1,
                maxWidth: context.mediaQuery.size.width,
                previewWidth: context.mediaQuery.size.width,
                previewHeight: (context.mediaQuery.size.width) / 16 * 9,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Pick an image',
                ),
                galleryLabel: const Text('Pick from Gallery'),
                // availableImageSources: const [
                //   ImageSourceOption.gallery,
                // ],
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(
                height: 64,
                child: Divider(),
              ),
              Text(
                'Basic Info',
                style: context.theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              FormBuilderTextField(
                name: 'name',
                initialValue: initialActivity?.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter activity name',
                  labelText: 'Name',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(50),
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              FormBuilderTextField(
                name: 'description',
                initialValue: initialActivity?.description,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(2000),
                ]),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Description'),
                  hintText: 'Write about what your activity does',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
