import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

class OrganizationJoinController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<OrganizationMember?> join(int organizationId) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 5));
    state = const AsyncData(null);
    return null;
    // try {
    //   final res = await ref
    //       .watch(organizationMemberRepositoryProvider)
    //       .join(organizationId);
    //   state = const AsyncData(null);
    //   return res;
    // } on BackendException catch (ex, st) {
    //   state = AsyncError(ex, st);
    // } catch (ex, st) {
    //   state = AsyncError('An error has happened', st);
    // }
    // return null;
  }
}

final organizationJoinControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrganizationJoinController, void>(
  () => OrganizationJoinController(),
);
