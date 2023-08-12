import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';

class NewsCreateBottomBar extends ConsumerWidget {
  const NewsCreateBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPublished = ref.watch(isPublishedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        SwitchListTile(
          title: const Text('Publish now'),
          value: isPublished,
          onChanged: (value) =>
              ref.read(isPublishedProvider.notifier).state = value,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.saveAndValidate()) {
                      return;
                    }
                    final formData = formKey.currentState!.value;
                    final String title = formData['title'];
                    final thumbnailValue = formData['thumbnail'];
                    Uint8List? thumbnail;
                    if (thumbnailValue != null) {
                      thumbnail = (thumbnailValue as List<dynamic>).isNotEmpty
                          ? thumbnailValue[0]
                          : null;
                    }
                    final content = ref
                        .read(quillControllerProvider)
                        .document
                        .toDelta()
                        .toJson();
                    ref.read(createNewsControllerProvider.notifier).createNews(
                          title: title,
                          thumbnailData: thumbnail,
                          content: content,
                          isPublished: isPublished,
                        );
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
