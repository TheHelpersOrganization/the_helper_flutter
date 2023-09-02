import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';

import 'package:the_helper/src/features/account/domain/account_log_query.dart';

import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';

import 'package:the_helper/src/features/organization/domain/organization_log_query.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';

import '../../../activity/application/activity_service.dart';
import '../../../organization/application/admin_organization_service.dart';
import '../../../report/application/report_service.dart';

part 'admin_home_controller.g.dart';

class AdminHomeDataModel {
  final int account;
  final int organization;
  final int activity;
  final int accountRequest;
  final int organizationRequest;
  final int report;

  AdminHomeDataModel({
    required this.account,
    required this.organization,
    required this.activity,
    required this.accountRequest,
    required this.organizationRequest,
    required this.report,
  });
}

class AdminChartDataModel {
  final DataLog account;
  final DataLog organization;
  final DataLog activity;

  AdminChartDataModel({
    required this.account,
    required this.organization,
    required this.activity,
  });
}

@riverpod
class AdminHomeData extends _$AdminHomeData {
  @override
  FutureOr<AdminHomeDataModel> build() async {
    return _fetchData();
  }

  Future<AdminHomeDataModel> _fetchData() async {
    final accountData = await ref.watch(accountServiceProvider).getLog();
    final organizationData = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(status: OrganizationStatus.verified));
    final activityData = await ref.watch(activityServiceProvider).getLog();

    final accountRequest =
        await ref.watch(accountServiceProvider).getRequestLog();
    final reportData = await ref.watch(reportServiceProvider).getLog();
    final organizationRequest = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(status: OrganizationStatus.pending));
    return AdminHomeDataModel(
      account: accountData.total,
      organization: organizationData.total,
      activity: activityData.total,
      accountRequest: accountRequest.total,
      organizationRequest: organizationRequest.total,
      report: reportData.total,
    );
  }
}

@riverpod
class AdminChartData extends _$AdminChartData {
  @override
  FutureOr<AdminChartDataModel> build(int filter) async {
    switch (filter) {
      case 1:
        return _getLastYear();
      case 2:
        return _getAllTime();
      default:
        return _getThisYear();
    }
  }

  Future<AdminChartDataModel> _getThisYear() async {
    final timeNow = DateTime.now();
    final startTime = DateTime(timeNow.year).millisecondsSinceEpoch;
    print(startTime);

    final accountData = await ref
        .watch(accountServiceProvider)
        .getLog(query: AccountLogQuery(startTime: startTime));
    final organizationData = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(
                status: OrganizationStatus.verified, startTime: startTime));
    final activityData = await ref
        .watch(activityServiceProvider)
        .getLog(query: ActivityLogQuery(startTime: startTime));

    print(activityData.monthly);

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  Future<AdminChartDataModel> _getLastYear() async {
    final timeNow = DateTime.now();
    final startTime = DateTime(timeNow.year - 1).millisecondsSinceEpoch;
    final endTime = DateTime(timeNow.year - 1, 12).millisecondsSinceEpoch;
    print(startTime);
    print(endTime);

    final accountData = await ref
        .watch(accountServiceProvider)
        .getLog(query: AccountLogQuery(startTime: startTime, endTime: endTime));
    final organizationData = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(
                status: OrganizationStatus.verified,
                startTime: startTime,
                endTime: endTime));
    final activityData = await ref.watch(activityServiceProvider).getLog(
        query: ActivityLogQuery(startTime: startTime, endTime: endTime));

    print(activityData.monthly);

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  Future<AdminChartDataModel> _getAllTime() async {
    final accountData = await ref.watch(accountServiceProvider).getLog();
    final organizationData = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(status: OrganizationStatus.verified));
    final activityData = await ref.watch(activityServiceProvider).getLog();

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }
}
