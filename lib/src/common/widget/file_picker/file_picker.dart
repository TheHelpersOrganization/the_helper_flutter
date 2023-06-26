import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class FilePickerWidget extends StatelessWidget {
  final Function(FilePickerResult) onPicked;
  final Function()? onCancel;
  final EdgeInsetsGeometry? margin;

  const FilePickerWidget({
    super.key,
    required this.onPicked,
    this.onCancel,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            withReadStream: true,
          );
          if (result == null) {
            onCancel?.call();
            return;
          }
          onPicked(result);
        },
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Choose a file to upload',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilledFilePickerWidget extends StatelessWidget {
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final PlatformFile file;
  final Function()? onRemove;

  const FilledFilePickerWidget({
    super.key,
    required this.file,
    this.isLoading = false,
    this.padding,
    this.margin,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final length = file.size;
    return Card(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Icon(
                      Icons.attach_file,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.redAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          file.extension?.toUpperCase() ?? 'File',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    length.toString(),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : Visibility(
                  visible: onRemove != null,
                  child: IconButton(
                    icon: const Icon(
                      Icons.clear_outlined,
                      color: Colors.black54,
                    ),
                    onPressed: () => onRemove?.call(),
                  ),
                ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
