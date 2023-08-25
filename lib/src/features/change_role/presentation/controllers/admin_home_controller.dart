import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';

import '../../../activity/application/activity_service.dart';
import '../../../organization/application/admin_organization_service.dart';
import '../../../report/application/report_service.dart';

class AdminHomeDataManage {
  final int account;
  final int organization;
  final int activity;
  final int accountRequest;
  final int organizationRequest;
  final int report;

  AdminHomeDataManage({
    required this.account,
    required this.organization,
    required this.activity,
    required this.accountRequest,
    required this.organizationRequest,
    required this.report,
  });
}

class AdminChartData {
  final ActivityLog account;
  final ActivityLog organization;
  final ActivityLog activity;

  AdminChartData({
    required this.account,
    required this.organization,
    required this.activity,
  });
}

final chartFilterProvider = StateProvider.autoDispose<int>((ref) => 0);
final openRankingProvider = StateProvider.autoDispose<bool>((ref) => false);
final segmentValueProvider = StateProvider.autoDispose<Set<int>>((ref) => {0});

final accountCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getCount());

final activityCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getCount());

final organizationCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(adminOrganizationServiceProvider).getCount());

final accountRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(accountServiceProvider).getRequestCount());

final organizationRequestCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(adminOrganizationServiceProvider).getRequestCount());

final reportCountProvider = FutureProvider.autoDispose<int>(
    (ref) => ref.watch(reportServiceProvider).getCount());

final chartActivityProvider = FutureProvider.autoDispose<ActivityLog>((ref) {
  final end = DateTime.now();
  final start = DateTime(end.year);
  return ref.watch(activityServiceProvider).getLog(
          query: ActivityLogQuery(
        startDate: start,
        // endDate: end
      ));
});

final chartAccountProvider = FutureProvider.autoDispose<ActivityLog>((ref) {
  final end = DateTime.now();
  final start = DateTime(end.year);
  return ref.watch(accountServiceProvider).getLog(
          query: ActivityLogQuery(
        startDate: start,
        // endDate: end
      ));
});

final chartOrganizationProvider =
    FutureProvider.autoDispose<ActivityLog>((ref) {
  final end = DateTime.now();
  final start = DateTime(end.year);
  return ref.watch(adminOrganizationServiceProvider).getLog(
          query: ActivityLogQuery(
        startDate: start,
        // endDate: end
      ));
});

final chartDataProvider =
    FutureProvider.autoDispose<AdminChartData>((ref) async {
  final accountData = await ref.watch(chartAccountProvider.future);
  final organizationData = await ref.watch(chartOrganizationProvider.future);
  final activityData = await ref.watch(chartActivityProvider.future);

  return AdminChartData(
      account: accountData,
      organization: organizationData,
      activity: activityData);
});

final adminHomeControllerProvider =
    FutureProvider.autoDispose<AdminHomeDataManage>((ref) async {
  final accountData = await ref.watch(accountCountProvider.future);
  final organizationData = await ref.watch(organizationCountProvider.future);
  final activityData = await ref.watch(activityCountProvider.future);

  final accountRequest = await ref.watch(accountRequestCountProvider.future);
  final reportData = await ref.watch(reportCountProvider.future);
  final organizationRequest =
      await ref.watch(organizationRequestCountProvider.future);

  return AdminHomeDataManage(
      account: accountData,
      organization: organizationData,
      activity: activityData,
      accountRequest: accountRequest,
      organizationRequest: organizationRequest,
      report: reportData);
});
