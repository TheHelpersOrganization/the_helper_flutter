import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';

import '../../../activity/application/activity_service.dart';
import '../../../activity/domain/activity_include.dart';
import '../../../activity/domain/activity_query.dart';
import '../../../organization/application/organization_service.dart';
import '../../../report/application/report_service.dart';

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

class PendingRequestData {
  final int account;
  final int organization;
  final int report;

  PendingRequestData({
    required this.account,
    required this.organization,
    required this.report,
  });
}

final accountCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getCount());

final upcomingActivitiesCountProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(activityServiceProvider).getCount(
        query: ActivityQuery(
          limit: 5,
          startDate: [
            DateTime.now(),
            DateTime.now().add(const Duration(days: 7))
          ],
        ),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

final organizationCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(organizationServiceProvider).getCount());

final accountRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getRequestCount());

final organizationRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(organizationServiceProvider).getRequestCount());

final reportCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(reportServiceProvider).getCount());

final adminHomeControllerProvider =
    FutureProvider.autoDispose<AdminHomeDataManage>((ref) async {
  final accountData = await ref.watch(accountCountProvider.future);
  final activityData = await ref.watch(upcomingActivitiesCountProvider.future);
  final organizationData =
      await ref.watch(upcomingActivitiesCountProvider.future);

  return AdminHomeDataManage(
      account: accountData,
      activity: activityData,
      organization: organizationData);
});

final adminRequestProvider =
    FutureProvider.autoDispose<PendingRequestData>((ref) async {
  final accountData = await ref.watch(accountRequestCountProvider.future);
  final reportData = await ref.watch(reportCountProvider.future);
  final organizationData =
      await ref.watch(organizationRequestCountProvider.future);

  return PendingRequestData(
      account: accountData, report: reportData, organization: organizationData);
});
