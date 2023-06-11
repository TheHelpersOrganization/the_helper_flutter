import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/update_activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/controller/mod_activity_list_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/utils/async_value.dart';

class UpdateActivityController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ModActivityRepository activityRepository;
  final FileRepository fileRepository;

  UpdateActivityController({
    required this.ref,
    required this.activityRepository,
    required this.fileRepository,
  }) : super(const AsyncData(null));

  Future<void> updateActivity({
    required int activityId,
    required UpdateActivity activity,
    Uint8List? thumbnailData,
  }) async {
    state = const AsyncValue.loading();

    int? thumbnail;
    if (thumbnailData != null) {
      final file = await guardAsyncValue(
          () => fileRepository.uploadWithBytes(thumbnailData));

      if (!mounted) {
        return;
      }

      if (file.hasError) {
        state = AsyncError(file.error!, file.stackTrace!);
        return;
      }
      thumbnail = file.value!.id;
    }

    final update =
        thumbnail != null ? activity.copyWith(thumbnail: thumbnail) : activity;
    final res = await guardAsyncValue(
      () => activityRepository.updateActivity(
        activityId: activityId,
        activity: update,
      ),
    );
    ref.invalidate(getActivityProvider);
    ref.invalidate(getActivityAndShiftsProvider);
    ref.invalidate(pagingControllerProvider);
    if (!mounted) {
      return;
    }
    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }
    state = const AsyncValue.data(null);
  }
}

final updateActivityControllerProvider = StateNotifierProvider.autoDispose<
    UpdateActivityController, AsyncValue<void>>(
  (ref) => UpdateActivityController(
    ref: ref,
    activityRepository: ref.watch(modActivityRepositoryProvider),
    fileRepository: ref.watch(fileRepositoryProvider),
  ),
);
