import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';

class NewsContent extends ConsumerStatefulWidget {
  final String content;
  final NewsContentFormat contentFormat;

  const NewsContent({
    super.key,
    required this.content,
    required this.contentFormat,
  });

  @override
  ConsumerState<NewsContent> createState() => _NewsContentInputState();
}

class _NewsContentInputState extends ConsumerState<NewsContent>
    with AfterLayoutMixin<NewsContent> {
  @override
  void afterFirstLayout(BuildContext context) {
    final initialContent = widget.content;
    final quillController = ref.read(quillControllerProvider.notifier);
    if (widget.contentFormat == NewsContentFormat.delta) {
      quillController.document =
          quill.Document.fromJson(jsonDecode(initialContent));
    } else {
      quillController.document = quill.Document()..insert(0, initialContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quillController = ref.watch(quillControllerProvider);

    return quill.QuillEditor.basic(
      controller: quillController,
      readOnly: true,
    );
  }
}
