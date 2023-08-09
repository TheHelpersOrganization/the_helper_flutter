import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/controller/mod_activity_list_management_controller.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

final currentStepProvider = StateProvider.autoDispose((ref) => 0);

final selectedContactsProvider =
    StateProvider.autoDispose<List<Contact>?>((ref) => null);
final selectedContactNameProvider =
    StateProvider.autoDispose<String?>((ref) => null);

class ActivityManagerData {
  final Account account;
  final List<OrganizationMember> managers;

  ActivityManagerData({
    required this.account,
    required this.managers,
  });
}

final activityManagersProvider = FutureProvider.autoDispose((ref) async {
  final org = await ref.watch(currentOrganizationProvider.future);
  final account = await ref.watch(authServiceProvider.future);

  final managers = await ref
      .watch(modOrganizationMemberRepositoryProvider)
      .getMemberWithAccountProfile(org!.id);
  // print(managers);

  return ActivityManagerData(account: account!.account, managers: managers);
});

final selectedManagersProvider = StateProvider.autoDispose<Set<int>?>(
  (ref) {
    return null;
  },
);

class CreateActivityController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final FileRepository fileRepository;
  final ModActivityRepository modActivityRepository;

  CreateActivityController({
    required this.ref,
    required this.fileRepository,
    required this.modActivityRepository,
  }) : super(const AsyncData(null));

  Future<void> createActivity({
    required String name,
    required String description,
    required List<int>? activityManagerIds,
    required List<Contact>? contacts,
    Uint8List? thumbnailData,
  }) async {
    state = const AsyncLoading();

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

    final currentOrganization =
        await ref.watch(currentOrganizationProvider.future);
    final res = await guardAsyncValue(
      () => modActivityRepository.createActivity(
        organizationId: currentOrganization!.id,
        activity: Activity(
          name: name,
          description: description,
          thumbnail: thumbnail,
          activityManagerIds: activityManagerIds,
          contacts: contacts,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }

    ref.watch(routerProvider).goNamed(
      AppRoute.organizationActivityManagement.name,
      pathParameters: {'activityId': res.value!.id.toString()},
    );
    // ref.watch(routerProvider).goNamed(
    //       AppRoute.organizationActivityListManagement.name,
    //     );
    state = const AsyncData(null);
  }
}

final createActivityControllerProvider = StateNotifierProvider.autoDispose<
    CreateActivityController, AsyncValue<void>>(
  (ref) {
    return CreateActivityController(
      ref: ref,
      fileRepository: ref.watch(fileRepositoryProvider),
      modActivityRepository: ref.watch(modActivityRepositoryProvider),
    );
  },
);
