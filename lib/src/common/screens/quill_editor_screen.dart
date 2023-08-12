import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class QuillEditorScreen extends StatefulWidget {
  final Widget? title;

  const QuillEditorScreen({
    super.key,
    this.title,
  });

  @override
  State<QuillEditorScreen> createState() => _QuillEditorScreenState();
}

class _QuillEditorScreenState extends State<QuillEditorScreen> {
  late quill.QuillController controller;

  @override
  void initState() {
    super.initState();
    controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          TextButton.icon(
            onPressed: () {
              final converter = QuillDeltaToHtmlConverter(
                controller.document.toDelta(),
                ConverterOptions.forEmail(),
              );
              context.pop(controller.document.toDelta().toJson());
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillToolbar.basic(
            controller: controller,
            showBackgroundColorButton: false,
            toolbarIconCrossAlignment: WrapCrossAlignment.start,
            toolbarIconAlignment: WrapAlignment.start,
            showSubscript: false,
            showSuperscript: false,
            showInlineCode: false,
            showCodeBlock: false,
            embedButtons: FlutterQuillEmbeds.buttons(
              onImagePickCallback: _onImagePickCallback,
              webImagePickImpl: _webImagePickImpl,
              showCameraButton: false,
              showVideoButton: false,
            ),
            showDividers: false,
          ),
          Expanded(
            child: quill.QuillEditor.basic(
              controller: controller,
              readOnly: false, // true for view only mode
            ),
          ),
        ],
      ),
    );
  }
}
