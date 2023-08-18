import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/quill_editor_screen.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';

class NewsContentInputData {
  final String content;
  final NewsContentFormat contentFormat;

  const NewsContentInputData({
    required this.content,
    required this.contentFormat,
  });
}

class NewsContentInput extends ConsumerStatefulWidget {
  final NewsContentInputData? initialValue;

  const NewsContentInput({
    super.key,
    this.initialValue,
  });

  @override
  ConsumerState<NewsContentInput> createState() => _NewsContentInputState();
}

class _NewsContentInputState extends ConsumerState<NewsContentInput>
    with AfterLayoutMixin<NewsContentInput> {
  @override
  void afterFirstLayout(BuildContext context) {
    final initialContent = widget.initialValue;
    if (initialContent == null) {
      return;
    }
    final quillController = ref.read(quillControllerProvider.notifier);
    if (initialContent.contentFormat == NewsContentFormat.delta) {
      quillController.document =
          quill.Document.fromJson(jsonDecode(initialContent.content));
    } else {
      quillController.document = quill.Document()
        ..insert(0, initialContent.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quillController = ref.watch(quillControllerProvider);
    final content = quillController.document.toDelta();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Content',
              style: context.theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () async {
                final delta = await context.navigator.push(
                  MaterialPageRoute(
                    builder: (context) => QuillEditorScreen(
                      title: const Text('Edit content'),
                      initial: content,
                    ),
                  ),
                );
                if (!context.mounted) {
                  return;
                }
                // ref.read(contentProvider.notifier).state = delta;
                quillController.document = quill.Document.fromDelta(delta);
              },
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20,
            ),
          ],
        ),
        const SizedBox(height: 8),
        quill.QuillEditor.basic(
          controller: quillController,
          readOnly: true,
        ),
      ],
    );
  }
}
