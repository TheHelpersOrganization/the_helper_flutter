import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';

import '../../data/profile_repository.dart';
import '../../domain/gender.dart';
import '../../domain/profile.dart';

final imageInputControllerProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final genderInputSelectionProvider =
    StateProvider.autoDispose<Gender?>((ref) => null);

class EditProfileAvatarController extends AutoDisposeAsyncNotifier<int?> {
  @override
  int? build() {
    final profile = ref.watch(editProfileControllerProvider);
    return profile.when(
      data: (data) => data.avatarId,
      error: (_, __) => null,
      loading: () => null,
    );
  }

  void updateAvatar(XFile path) async {
    state = const AsyncValue.loading();
    try {
      final fileModel = await ref.read(fileRepositoryProvider).upload(path);
      final profile = ref.read(editProfileControllerProvider).valueOrNull;
      if (profile == null) {
        return;
      }
      await ref
          .watch(editProfileControllerProvider.notifier)
          .updateProfile(profile.copyWith(avatarId: fileModel.id));
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    }
  }
}

class EditProfileController extends AutoDisposeAsyncNotifier<Profile> {
  @override
  FutureOr<Profile> build() async {
    final profile = await ref.watch(profileRepositoryProvider).getProfile();
    return profile;
  }

  Future<void> updateProfile(
    Profile profile,
  ) async {
    state = const AsyncValue.loading();
    try {
      final res =
          await ref.read(profileRepositoryProvider).updateProfile(profile);
      state = AsyncValue.data(res);
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    }
  }
}

final editProfileControllerProvider =
    AutoDisposeAsyncNotifierProvider<EditProfileController, Profile>(
        () => EditProfileController());

final editProfileAvatarControllerProvider =
    AutoDisposeAsyncNotifierProvider<EditProfileAvatarController, int?>(
        () => EditProfileAvatarController());
