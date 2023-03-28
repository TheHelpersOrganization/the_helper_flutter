import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:the_helper/src/common/widget/image_picker/custom_image_picker.dart';

class FormCustomImagePickerField extends FormBuilderField<XFile> {
  FormCustomImagePickerField({
    super.key,
    required super.name,
    Widget? image,
    bool isLoading = false,
    Function(XFile file)? onImagePicked,
    EdgeInsetsGeometry? pickerPadding,
    ShapeBorder? shape,
    super.validator,
  }) : super(
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImagePickerWidget(
                  image: image,
                  onImagePicked: (file) {
                    state.didChange(file);
                    onImagePicked?.call(file);
                  },
                  isLoading: isLoading,
                  pickerPadding: pickerPadding,
                  shape: shape,
                ),
                if (state.hasError)
                  Text(
                    state.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}
