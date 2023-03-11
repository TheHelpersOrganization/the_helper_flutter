import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/exception/backend_exception.dart';

import '../data/profile_repository.dart';
import '../domain/gender.dart';
import '../domain/profile.dart';

final imageInputControllerProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final genderInputSelectionProvider =
    StateProvider.autoDispose<Gender?>((ref) => null);

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
