import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class CustomImagePickerWidget extends StatelessWidget {
  final Widget? image;
  final bool isLoading;
  final Function(XFile file)? onImagePicked;
  final EdgeInsetsGeometry? pickerPadding;
  final ShapeBorder? shape;

  const CustomImagePickerWidget({
    super.key,
    this.image,
    this.onImagePicked,
    this.isLoading = false,
    this.pickerPadding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (image != null) image!,
        if (!isLoading)
          RawMaterialButton(
            onPressed: () async {
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file == null) {
                return;
              }
              onImagePicked?.call(file);
            },
            elevation: 2.0,
            fillColor: Colors.transparent,
            padding: pickerPadding == null
                ? EdgeInsets.all(context.mediaQuery.size.width * 0.15 - 12)
                : pickerPadding!,
            shape: shape ?? const CircleBorder(),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 24,
            ),
          )
        else
          const CircularProgressIndicator()
      ],
    );
  }
}
