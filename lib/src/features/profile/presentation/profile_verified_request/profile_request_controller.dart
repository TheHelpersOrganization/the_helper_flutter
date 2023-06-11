import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/profile/domain/verified_request.dart';
import 'package:the_helper/src/utils/async_value.dart';

import '../../../file/data/file_repository.dart';
import '../../data/profile_repository.dart';

part 'profile_request_controller.g.dart';

final expansionTitleControllerProvider =
    StateProvider.autoDispose<bool>((ref) => true);

@riverpod
class ProfileVerifiedRequestController
    extends _$ProfileVerifiedRequestController {
  @override
  void build() {
    return;
  }

  Future<VerifiedRequest?> sendVerifiedRequest({
    List<PlatformFile>? files,
  }) async {
    const AsyncLoading();
    final fileRepo = ref.read(fileRepositoryProvider);

    final fileFutures = files
            ?.map(
              (file) => fileRepo.uploadWithPlatformFile(
                file,
              ),
            )
            .toList() ??
        [];

    final fileModels = await Future.wait(fileFutures);
    final date = DateTime.now();

    final res = await guardAsyncValue(() => ref
        .watch(profileRepositoryProvider)
        .requestVerifiedProfile(VerifiedRequest(
          requestDate: date,
          files: fileModels.map((e) => e.id).toList(),
        )));
    return res.valueOrNull;
  }
}
