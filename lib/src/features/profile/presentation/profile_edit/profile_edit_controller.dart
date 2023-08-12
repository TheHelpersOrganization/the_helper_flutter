import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';

import '../../data/profile_repository.dart';
import '../../domain/gender.dart';
import '../../domain/profile.dart';

final imageInputControllerProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final genderInputSelectionProvider =
    StateProvider.autoDispose<Gender?>((ref) => null);

final basicInfoValurChangeProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final selectedSkillsProvider =
    StateProvider.autoDispose<Set<Skill>?>((ref) => null);

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

class ProfileEditAvatarController extends AutoDisposeAsyncNotifier<int?> {
  @override
  int? build() {
    final profile = ref.watch(profileEditControllerProvider);
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
      final profile = ref.read(profileEditControllerProvider).valueOrNull;
      if (profile == null) {
        return;
      }
      await ref
          .watch(profileEditControllerProvider.notifier)
          .updateProfile(profile.copyWith(avatarId: fileModel.id));
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    }
  }
}

class ProfileEditController extends AutoDisposeAsyncNotifier<Profile> {
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

class SkillEditController extends AutoDisposeAsyncNotifier<List<Skill>> {
  @override
  FutureOr<List<Skill>> build() async {
    final name = ref.watch(searchPatternProvider);
    final skills = await ref.watch(skillRepositoryProvider).getSkills(
            query: SkillQuery(
          name: name,
        ));
    return skills;
  }
}

final profileEditControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileEditController, Profile>(
        () => ProfileEditController());

final profileEditAvatarControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileEditAvatarController, int?>(
        () => ProfileEditAvatarController());

final skillEditControllerProvider =
    AutoDisposeAsyncNotifierProvider<SkillEditController, List<Skill>>(
        () => SkillEditController());
