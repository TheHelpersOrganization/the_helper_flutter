import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';

class NewsCreateBottomBar extends ConsumerWidget {
  final NewsUpdateMode mode;
  final News? initialNews;

  const NewsCreateBottomBar({
    super.key,
    required this.mode,
    this.initialNews,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPublished =
        ref.watch(isPublishedProvider) ?? initialNews?.isPublished ?? false;
    final isThumbnailChanged = ref.watch(hasChangeThumbnailProvider);

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

                    print(isThumbnailChanged);
                    Uint8List? thumbnailData;
                    int? thumbnailId;
                    if (isThumbnailChanged) {
                      final thumbnailValue = formData['thumbnail'];
                      if (thumbnailValue != null) {
                        thumbnailData =
                            (thumbnailValue as List<dynamic>).isNotEmpty
                                ? thumbnailValue[0]
                                : null;
                      }
                    } else {
                      thumbnailId = initialNews?.thumbnail;
                    }

                    final content = ref
                        .read(quillControllerProvider)
                        .document
                        .toDelta()
                        .toJson();

                    final activity = ref.read(activityInputProvider);
                    final type =
                        activity == null ? NewsType.general : NewsType.activity;

                    if (mode.isCreate) {
                      ref
                          .read(createNewsControllerProvider.notifier)
                          .createNews(
                            type: type,
                            title: title,
                            thumbnail: thumbnailData == null
                                ? null
                                : NewsThumbnail(
                                    thumbnailData: thumbnailData,
                                  ),
                            content: content,
                            isPublished: isPublished,
                            activityId: activity?.id,
                          );
                    } else {
                      ref
                          .read(createNewsControllerProvider.notifier)
                          .updateNews(
                            id: initialNews!.id,
                            type: type,
                            title: title,
                            thumbnail: NewsThumbnail(
                              thumbnailData: thumbnailData,
                              thumbnailId: thumbnailId,
                            ),
                            content: content,
                            isPublished: isPublished,
                            activityId: activity?.id,
                          );
                    }
                  },
                  child: Text(mode.isCreate ? 'Create' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
