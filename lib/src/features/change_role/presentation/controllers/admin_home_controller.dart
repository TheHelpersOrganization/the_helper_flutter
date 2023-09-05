import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';

import 'package:the_helper/src/features/account/domain/account_log_query.dart';

import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/admin_analytic/data/analytic_repository.dart';
import 'package:the_helper/src/features/admin_analytic/domain/account_analytic_model.dart';
import 'package:the_helper/src/features/admin_analytic/domain/activity_analytic_model.dart';
import 'package:the_helper/src/features/admin_analytic/domain/organization_analytic_model.dart';
import 'package:the_helper/src/features/admin_analytic/domain/rank_query.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

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

class AdminRankingDataModel {
  final List<AccountAnalyticModel>? account;
  final List<OrganizationAnalyticModel>? organization;
  final List<ActivityAnalyticModel>? activity;

  AdminRankingDataModel({
    this.account,
    this.organization,
    this.activity,
  });
}

final isAccountLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final isOrganizationLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final isActivityLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);

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
    final startTime = DateTime.utc(timeNow.year).millisecondsSinceEpoch;

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

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  Future<AdminChartDataModel> _getLastYear() async {
    final timeNow = DateTime.now();
    final startTime = DateTime.utc(timeNow.year - 1).millisecondsSinceEpoch;
    final endTime = DateTime.utc(timeNow.year).millisecondsSinceEpoch;

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
        query: ActivityLogQuery(
            status: [ActivityStatus.completed, ActivityStatus.ongoing],
            startTime: startTime,
            endTime: endTime));

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

@riverpod
class AdminRankingData extends _$AdminRankingData {
  @override
  FutureOr<AdminRankingDataModel> build(int filter) async {
    return _fetchData(filter);
  }

  Future<AdminRankingDataModel> _fetchData(int filter) async {
    final adminRankingRepo = ref.watch(adminAnalyticRepositoryProvider);
    List<ActivityAnalyticModel> tempList = [];
    const query = RankQuery();

    final accountData = filter == 0
        ? await adminRankingRepo.getAccountsRank(query: query)
        : null;
    final organizationData = filter == 1
        ? await adminRankingRepo.getOrganizationsRank(query: query)
        : null;
    List<ActivityAnalyticModel> activityData = filter == 2
        ? await adminRankingRepo.getActivitiesRank(query: query)
        : [];

    for (var i in activityData) {
      final orgData = await ref
          .watch(organizationRepositoryProvider)
          .getById(i.organizationId!);
      tempList.add(i.copyWith(
          organizationLogo: orgData.logo, organizationName: orgData.name));
    }

    activityData = tempList;

    return AdminRankingDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }
}
