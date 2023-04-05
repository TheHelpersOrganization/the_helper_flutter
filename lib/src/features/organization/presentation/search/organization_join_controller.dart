import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

final joinedOrganizationIdsProvider =
    StateProvider.autoDispose<Set<int>>((ref) => {});

class OrganizationJoinController extends AutoDisposeAsyncNotifier<void> {
  final CancelToken? token = null;

  @override
  void build() {
    ref.onDispose(() => token?.cancel());
    final orgIds = ref.watch(joinedOrganizationIdsProvider);
  }

  Future<OrganizationMember?> join(int organizationId) async {
    state = const AsyncLoading();
    try {
      final res = await ref
          .watch(organizationMemberRepositoryProvider)
          .join(organizationId);
      state = const AsyncData(null);
      ref.read(joinedOrganizationIdsProvider.notifier).update(
            (state) => {
              ...state,
              organizationId,
            },
          );
      return res;
    } on BackendException catch (ex, st) {
      state = AsyncError(ex, st);
    } catch (ex, st) {
      state = AsyncError('An error has happened', st);
    }
    return null;
  }
}

final organizationJoinControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrganizationJoinController, void>(
  () => OrganizationJoinController(),
);
