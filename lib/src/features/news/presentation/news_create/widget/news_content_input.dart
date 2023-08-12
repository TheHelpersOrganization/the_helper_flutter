import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/quill_editor_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';

class NewsContentInput extends ConsumerWidget {
  const NewsContentInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final converter = QuillDeltaToHtmlConverter(
    //   content.toJson() as dynamic,
    //   ConverterOptions.forEmail(),
    // );

    // final html = converter.convert();

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
