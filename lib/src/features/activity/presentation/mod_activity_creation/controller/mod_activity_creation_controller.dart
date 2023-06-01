import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/async_value.dart';

class ActivityManagerData {
  final Account account;
  final List<OrganizationMember> activityManagers;

  ActivityManagerData({
    required this.account,
    required this.activityManagers,
  });
}

final activityManagersProvider = FutureProvider.autoDispose((ref) async {
  final org = await ref.watch(currentOrganizationProvider.future);
  final account = await ref.watch(authServiceProvider.future);

  final managers = await ref
      .watch(modOrganizationMemberRepositoryProvider)
      .getMemberWithAccountProfile(org!.id!);

  return ActivityManagerData(
      account: account!.account, activityManagers: managers);
});

final activityManagerSelectionProvider = StateProvider.autoDispose<Set<int>>(
  (ref) {
    return {};
  },
);

class CreateActivityController extends AutoDisposeAsyncNotifier<void> {
  late ModActivityRepository _modActivityRepository;
  late FileRepository _fileRepository;

  @override
  FutureOr<void> build() {
    _modActivityRepository = ref.watch(modActivityRepositoryProvider);
    _fileRepository = ref.watch(fileRepositoryProvider);
    return null;
  }

  Future<Activity?> createActivity({
    required String name,
    required String description,
    required List<int> activityManagerIds,
    Uint8List? thumbnailData,
  }) async {
    state = const AsyncLoading();
    int? thumbnail;
    if (thumbnailData != null) {
      final file = await guardAsyncValue(
          () => _fileRepository.uploadWithBytes(thumbnailData));
      if (file.hasError) {
        state = AsyncError(file.error!, file.stackTrace!);
        return null;
      }
      thumbnail = file.value!.id;
    }
    final currentOrganization =
        await ref.watch(currentOrganizationProvider.future);
    final res = await guardAsyncValue(
      () => _modActivityRepository.createActivity(
        organizationId: currentOrganization!.id!,
        activity: Activity(
          name: name,
          description: description,
          thumbnail: thumbnail,
          activityManagerIds: activityManagerIds,
        ),
      ),
    );
    if (res.hasError) {
      print(res.stackTrace);
      print(res.error);
      state = AsyncError(res.error!, res.stackTrace!);
      return null;
    }
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<void> test() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 3));
    state = const AsyncData(null);
  }
}

final createActivityControllerProvider =
    AutoDisposeAsyncNotifierProvider<CreateActivityController, void>(
  () => CreateActivityController(),
);
