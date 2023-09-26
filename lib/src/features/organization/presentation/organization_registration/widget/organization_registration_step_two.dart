import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/image_picker/form_custom_image_picker.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/controller/organization_registration_controller.dart';

final organizationRegistrationStepTwoFormKey = GlobalKey<FormBuilderState>();

class OrganizationRegistrationStepTwo extends ConsumerWidget {
  const OrganizationRegistrationStepTwo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? logoUrl = ref.watch(logoUrlProvider);
    String? bannerUrl = ref.watch(bannerUrlProvider);

    ImageProvider? logoImage;
    if (logoUrl != null) {
      if (kIsWeb) {
        logoImage = NetworkImage(logoUrl);
      } else {
        logoImage = Image.file(File(logoUrl)).image;
      }
    }

    ImageProvider? bannerImage;
    if (bannerUrl != null) {
      if (kIsWeb) {
        bannerImage = NetworkImage(bannerUrl);
      } else {
        bannerImage = Image.file(File(bannerUrl)).image;
      }
    }

    return SingleChildScrollView(
      child: FormBuilder(
        key: organizationRegistrationStepTwoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Banner',
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            FormCustomImagePickerField(
              name: 'banner',
              image: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: bannerImage == null
                    ? SizedBox(
                        width: context.mediaQuery.size.width * 0.8,
                        height: 128,
                      )
                    : Image(
                        image: bannerImage,
                        width: context.mediaQuery.size.width * 0.8,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
              ),
              onImagePicked: (file) =>
                  ref.read(bannerUrlProvider.notifier).state = file.path,
              shape: const RoundedRectangleBorder(),
              pickerPadding: EdgeInsets.symmetric(
                vertical: 64 - 12,
                horizontal: context.mediaQuery.size.width * 0.4 - 12,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Divider(),
            RequiredText(
              'Logo',
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            FormCustomImagePickerField(
              name: 'logo',
              image: CircleAvatar(
                radius: context.mediaQuery.size.width * 0.15,
                backgroundImage: logoImage,
                backgroundColor: Colors.grey.withAlpha(10),
              ),
              onImagePicked: (file) =>
                  ref.read(logoUrlProvider.notifier).state = file.path,
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
