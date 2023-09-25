import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_helper/src/features/activity/domain/minimal_activity.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/domain/create_news.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/news/domain/update_news.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

enum NewsUpdateMode {
  create,
  update,
  ;

  bool get isCreate => this == NewsUpdateMode.create;
  bool get isUpdate => this == NewsUpdateMode.update;
}

final newsProvider =
    FutureProvider.autoDispose.family<News?, int?>((ref, id) async {
  if (id == null) {
    return null;
  }
  return ref.watch(newsRepositoryProvider).getNewsById(
      id: id,
      query: NewsByIdQuery(
        include: NewsQueryInclude.all,
      ));
});

final formKey = GlobalKey<FormBuilderState>();

final quillControllerProvider =
    ChangeNotifierProvider.autoDispose<quill.QuillController>(
  (ref) => quill.QuillController.basic(),
);
final isPublishedProvider = StateProvider.autoDispose<bool?>((ref) => null);

final activityInputFocusNode = ChangeNotifierProvider.autoDispose((ref) {
  final focusNode = FocusNode();
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      ref.read(activityInputIsEditingProvider.notifier).state = false;
    }
  });
  return focusNode;
});
final activityInputIsEditingProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final activityInputProvider =
    StateProvider.autoDispose<MinimalActivity?>((ref) => null);
final hasChangeThumbnailProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class NewsThumbnail {
  final int? thumbnailId;
  final Uint8List? thumbnailData;

  NewsThumbnail({
    this.thumbnailData,
    this.thumbnailId,
  });
}

class CreateNewsController extends AutoDisposeAsyncNotifier<void> {
  late FileRepository _fileRepository;
  late NewsRepository _newsRepository;

  @override
  FutureOr<void> build() {
    _fileRepository = ref.watch(fileRepositoryProvider);
    _newsRepository = ref.watch(newsRepositoryProvider);
  }

  Future<void> replaceLocalImagesWithRemoteImages(List<dynamic> content) async {
    for (var operation in content) {
      if (operation['insert'] is Map &&
          operation['insert'].containsKey('image') &&
          operation['insert']['image'] != "" &&
          !Uri.parse(operation['insert']['image']).isAbsolute) {
        String oldImagePath = await operation['insert']['image'];
        FileModel fileModel = await _fileRepository.upload(XFile(oldImagePath));
        operation['insert']['image'] = fileModel.asImageUrl;
      }
    }
  }

  Future<void> createNews({
    required NewsType type,
    required String title,
    required List<dynamic> content,
    required NewsThumbnail? thumbnail,
    required bool isPublished,
    required int? activityId,
  }) async {
    state = const AsyncValue.loading();

    final currentOrganization =
        await ref.watch(currentOrganizationServiceProvider.future);
    final organizationId = currentOrganization!.id;

    int? thumbnailId;
    if (thumbnail != null) {
      final thumbnailData = thumbnail.thumbnailData;
      final id = thumbnail.thumbnailId;
      if (thumbnailData != null) {
        final file = await guardAsyncValue(
            () => _fileRepository.uploadWithBytes(thumbnailData));

        if (file.hasError) {
          state = AsyncError(file.error!, file.stackTrace!);
          return;
        }
        thumbnailId = file.value!.id;
      } else {
        thumbnailId = id;
      }
    }

    await replaceLocalImagesWithRemoteImages(content);

    final res = await guardAsyncValue(
      () => _newsRepository.createNews(
        data: CreateNews(
          type: type,
          organizationId: organizationId,
          title: title,
          thumbnail: thumbnailId,
          content: jsonEncode(content),
          contentFormat: NewsContentFormat.delta,
          isPublished: isPublished,
          activityId: activityId,
        ),
      ),
    );

    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }

    ref.watch(routerProvider).goNamed(AppRoute.news.name);
    ref.invalidate(organizationNewsListPagedNotifierProvider);

    state = const AsyncValue.data(null);
  }

  Future<void> updateNews({
    required int id,
    required NewsType type,
    required String title,
    required List<dynamic> content,
    required NewsThumbnail? thumbnail,
    required bool isPublished,
    required int? activityId,
  }) async {
    state = const AsyncValue.loading();

    int? thumbnailId;
    if (thumbnail != null) {
      final thumbnailData = thumbnail.thumbnailData;
      final id = thumbnail.thumbnailId;
      if (thumbnailData != null) {
        final file = await guardAsyncValue(
            () => _fileRepository.uploadWithBytes(thumbnailData));

        if (file.hasError) {
          state = AsyncError(file.error!, file.stackTrace!);
          return;
        }
        thumbnailId = file.value!.id;
      } else {
        thumbnailId = id;
      }
    }

    await replaceLocalImagesWithRemoteImages(content);

    final res = await guardAsyncValue(
      () => _newsRepository.updateNews(
        id: id,
        data: UpdateNews(
          type: type,
          title: title,
          thumbnail: thumbnailId,
          content: jsonEncode(content),
          contentFormat: NewsContentFormat.delta,
          isPublished: isPublished,
          activityId: activityId,
        ),
      ),
    );

    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }

    ref.watch(routerProvider).goNamed(AppRoute.news.name);
    ref.invalidate(organizationNewsListPagedNotifierProvider);

    state = const AsyncValue.data(null);
  }
}

final createNewsControllerProvider =
    AutoDisposeAsyncNotifierProvider<CreateNewsController, void>(
  () => CreateNewsController(),
);
