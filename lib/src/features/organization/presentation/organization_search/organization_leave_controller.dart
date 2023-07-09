import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

final leavedOrganizationIdsProvider =
    StateProvider.autoDispose<Set<int>>((ref) => {});

class OrganizationLeaveController extends AutoDisposeAsyncNotifier<void> {
  final CancelToken? token = null;

  @override
  void build() {
    ref.onDispose(() => token?.cancel());
    final orgIds = ref.watch(leavedOrganizationIdsProvider);
  }

  Future<OrganizationMember?> leave(int organizationId) async {
    state = const AsyncLoading();
    try {
      final res = await ref
          .watch(organizationMemberRepositoryProvider)
          .leave(organizationId);
      state = const AsyncData(null);
      ref.read(leavedOrganizationIdsProvider.notifier).update(
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

final organizationLeaveControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrganizationLeaveController, void>(
  () => OrganizationLeaveController(),
);
