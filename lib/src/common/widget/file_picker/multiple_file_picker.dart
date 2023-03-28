import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/widget/file_picker/file_picker.dart';

class MultipleFilesPickerWidget extends StatefulWidget {
  final Function(List<PlatformFile> files)? onChanged;
  final Function(List<PlatformFile> files)? onPicked;
  final Function(List<PlatformFile> files)? onRemoved;

  const MultipleFilesPickerWidget({
    super.key,
    this.onChanged,
    this.onPicked,
    this.onRemoved,
  });

  @override
  State<MultipleFilesPickerWidget> createState() =>
      _MultipleFilesPickerWidgetState();
}

class _MultipleFilesPickerWidgetState extends State<MultipleFilesPickerWidget> {
  List<PlatformFile> _files = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._files
            .asMap()
            .map(
              (index, file) => MapEntry(
                index,
                FilledFilePickerWidget(
                  file: file,
                  onRemove: () {
                    setState(() {
                      _files.removeAt(index);
                    });
                    widget.onRemoved?.call([file]);
                  },
                ),
              ),
            )
            .values
            .toList(),
        FilePickerWidget(
          onPicked: (result) {
            setState(() {
              _files = _files + result.files;
            });
            widget.onPicked?.call(result.files);
            widget.onChanged?.call(_files);
          },
        ),
      ],
    );
  }
}
