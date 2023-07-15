import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';

import '../../../activity/application/activity_service.dart';
import '../../../activity/domain/activity_include.dart';
import '../../../activity/domain/activity_query.dart';
import '../../../organization/application/admin_organization_service.dart';
import '../../../report/application/report_service.dart';

class AdminHomeDataManage {
  final int account;
  final int organization;

  AdminHomeDataManage({
    required this.account,
    required this.organization,
  });
}

class PendingRequestData {
  final int account;
  final int report;

  PendingRequestData({
    required this.account,
    required this.report,
  });
}

final accountCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getCount());

final organizationCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(adminOrganizationServiceProvider).getCount());

final accountRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getRequestCount());

final organizationRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(adminOrganizationServiceProvider).getRequestCount());

final reportCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(reportServiceProvider).getCount());

final chartDataProvider = FutureProvider.autoDispose<ActivityLog>((ref) {
  final end = DateTime.now();
  final start = DateTime(end.year);
  return ref
      .watch(activityServiceProvider)
      .getLog(query: ActivityLogQuery(
        startDate: start,
        // endDate: end
      ));
});

final adminHomeControllerProvider =
    FutureProvider.autoDispose<AdminHomeDataManage>((ref) async {
  final accountData = await ref.watch(accountCountProvider.future);
  final organizationData = await ref.watch(organizationCountProvider.future);

  return AdminHomeDataManage(
      account: accountData, organization: organizationData);
});

final adminRequestProvider =
    FutureProvider.autoDispose<PendingRequestData>((ref) async {
  final accountData = await ref.watch(accountRequestCountProvider.future);
  final reportData = await ref.watch(reportCountProvider.future);

  return PendingRequestData(account: accountData, report: reportData);
});
