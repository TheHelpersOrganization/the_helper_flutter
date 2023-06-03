import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';

import '../../../activity/application/activity_service.dart';
import '../../../activity/domain/activity.dart';
import '../../../activity/domain/activity_include.dart';
import '../../../activity/domain/activity_query.dart';
import '../../../organization/application/organization_service.dart';

class AdminHomeDataManage {
  final int account;
  final int activity;
  final int organization;

  AdminHomeDataManage({
    required this.account,
    required this.activity,
    required this.organization,
  });
}

final accountCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getCount());

final upcomingActivitiesCountProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(activityServiceProvider).getCount(
        query: ActivityQuery(
          limit: 5,
          startDate: [DateTime.now(), DateTime.now().add(const Duration(days: 7))],
        ),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

final organizationCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(organizationServiceProvider).getCount());

final adminHomeControllerProvider =
    FutureProvider.autoDispose<AdminHomeDataManage>((ref) async {
  final accountData = await ref.watch(accountCountProvider.future);
  final activityData = await ref.watch(upcomingActivitiesCountProvider.future);
  final organizationData = await ref.watch(upcomingActivitiesCountProvider.future);

  return AdminHomeDataManage(
      account: accountData, activity: activityData, organization: organizationData);
});
