import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/domain/create_news.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/organization_news_list/controller/organization_news_list_controller.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

final formKey = GlobalKey<FormBuilderState>();

final quillControllerProvider =
    ChangeNotifierProvider.autoDispose<quill.QuillController>(
  (ref) => quill.QuillController(
    document: quill.Document.fromJson([
      {
        'insert': 'This is news content\n',
      }
    ]),
    selection: const TextSelection.collapsed(offset: 0),
  ),
);
final isPublishedProvider = StateProvider.autoDispose<bool>((ref) => false);

class CreateNewsController extends AutoDisposeAsyncNotifier<void> {
  late FileRepository _fileRepository;
  late NewsRepository _newsRepository;

  @override
  FutureOr<void> build() {
    _fileRepository = ref.watch(fileRepositoryProvider);
    _newsRepository = ref.watch(newsRepositoryProvider);
  }

  Future<void> createNews({
    required String title,
    required List<dynamic> content,
    required Uint8List? thumbnailData,
    required bool isPublished,
  }) async {
    state = const AsyncValue.loading();

    final currentOrganization =
        await ref.watch(currentOrganizationServiceProvider.future);
    final organizationId = currentOrganization!.id;

    int? thumbnail;
    if (thumbnailData != null) {
      final file = await guardAsyncValue(
          () => _fileRepository.uploadWithBytes(thumbnailData));

      if (file.hasError) {
        state = AsyncError(file.error!, file.stackTrace!);
        return;
      }
      thumbnail = file.value!.id;
    }

    final res = await guardAsyncValue(
      () => _newsRepository.createNews(
        data: CreateNews(
          organizationId: organizationId,
          title: title,
          thumbnail: thumbnail,
          content: jsonEncode(content),
          contentFormat: NewsContentFormat.delta,
          isPublished: isPublished,
        ),
      ),
    );

    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }

    ref.watch(routerProvider).goNamed(AppRoute.organizationNews.name);
    ref.invalidate(organizationNewsListPagedNotifierProvider);

    state = const AsyncValue.data(null);
  }
}

final createNewsControllerProvider =
    AutoDisposeAsyncNotifierProvider<CreateNewsController, void>(
  () => CreateNewsController(),
);
