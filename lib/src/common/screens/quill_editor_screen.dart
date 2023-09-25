import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class QuillEditorScreen extends StatefulWidget {
  final Widget? title;
  final Delta? initial;

  const QuillEditorScreen({
    super.key,
    this.title,
    this.initial,
  });

  @override
  State<QuillEditorScreen> createState() => _QuillEditorScreenState();
}

class _QuillEditorScreenState extends State<QuillEditorScreen> {
  late quill.QuillController controller;

  @override
  void initState() {
    super.initState();
    controller = quill.QuillController(
      document: widget.initial == null
          ? quill.Document()
          : quill.Document.fromDelta(widget.initial!),
      selection: const TextSelection.collapsed(offset: 0),
    );
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
        leading: IconButton(
          onPressed: () {
            context.pop(controller.document.toDelta());
          },
          icon: Icon(
            Icons.check,
            color: context.theme.primaryColor,
          ),
        ),
        title: title,
        actions: [
          quill.HistoryButton(
            controller: controller,
            icon: Icons.undo,
            undo: true,
            iconSize: 24,
          ),
          quill.HistoryButton(
            controller: controller,
            icon: Icons.redo,
            undo: false,
            iconSize: 24,
          ),
          quill.SearchButton(
            icon: Icons.search,
            controller: controller,
            iconSize: 24,
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
            showUndo: false,
            showRedo: false,
            showBoldButton: false,
            showItalicButton: false,
            showUnderLineButton: false,
            showStrikeThrough: false,
            showColorButton: false,
            showSubscript: false,
            showSuperscript: false,
            showInlineCode: false,
            showCodeBlock: false,
            showAlignmentButtons: false,
            showListCheck: false,
            showSearchButton: false,
            showLink: false,
            showDividers: false,
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: quill.QuillEditor.basic(
                controller: controller,
                readOnly: false, // true for view only mode
                embedBuilders: FlutterQuillEmbeds.builders(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    quill.ToggleStyleButton(
                      controller: controller,
                      attribute: const quill.BoldAttribute(),
                      icon: Icons.format_bold,
                    ),
                    quill.ToggleStyleButton(
                      controller: controller,
                      attribute: const quill.ItalicAttribute(),
                      icon: Icons.format_italic_outlined,
                    ),
                    quill.ToggleStyleButton(
                      controller: controller,
                      attribute: const quill.UnderlineAttribute(),
                      icon: Icons.format_underline,
                    ),
                    quill.ColorButton(
                      controller: controller,
                      icon: Icons.format_color_text,
                      background: false,
                    ),
                    quill.SelectAlignmentButton(
                      controller: controller,
                      showLeftAlignment: true,
                      showRightAlignment: true,
                      showCenterAlignment: true,
                      showJustifyAlignment: false,
                    ),
                    ImageButton(
                      icon: Icons.image,
                      controller: controller,
                      onImagePickCallback: _onImagePickCallback,
                    ),
                    quill.LinkStyleButton(
                      controller: controller,
                      icon: Icons.link,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
