import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/common/domain/data_monthly_log.dart';
import 'package:the_helper/src/common/domain/data_yearly_log.dart';
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
  final List<ActivityAnalyticModel>? activityByJoined;
  final List<ActivityAnalyticModel>? activityByRating;

  AdminRankingDataModel({
    this.account,
    this.organization,
    this.activityByJoined,
    this.activityByRating,
  });
}

final isAccountLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final isOrganizationLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final isActivityLineSeenProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final showToolTip = StateProvider.autoDispose<int>((ref) => -1);
final sortByTrending = StateProvider.autoDispose<bool>((ref) => false);

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
    final activityData = await ref
        .watch(activityServiceProvider)
        .getLog(query: ActivityLogQuery(status: [ActivityStatus.ongoing]));

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

    final accountRes = await ref
        .watch(accountServiceProvider)
        .getLog(query: AccountLogQuery(startTime: startTime));
    final organizationRes = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(
                status: OrganizationStatus.verified, startTime: startTime));
    final activityRes = await ref.watch(activityServiceProvider).getLog(
        query: ActivityLogQuery(
            status: [ActivityStatus.completed, ActivityStatus.ongoing],
            startTime: startTime));

    DataLog accountData =
        arrangeMonthlyDataLog(timeNow: timeNow, data: accountRes);

    DataLog organizationData =
        arrangeMonthlyDataLog(timeNow: timeNow, data: organizationRes);

    DataLog activityData =
        arrangeMonthlyDataLog(timeNow: timeNow, data: activityRes);

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  Future<AdminChartDataModel> _getLastYear() async {
    final timeNow = DateTime.now();
    final startTime = DateTime.utc(timeNow.year - 1).millisecondsSinceEpoch;

    final accountRes = await ref
        .watch(accountServiceProvider)
        .getLog(query: AccountLogQuery(startTime: startTime));
    final organizationRes =
        await ref.watch(adminOrganizationServiceProvider).getLog(
                query: OrganizationLogQuery(
              status: OrganizationStatus.verified,
              startTime: startTime,
            ));
    final activityRes = await ref.watch(activityServiceProvider).getLog(
            query: ActivityLogQuery(
          status: [ActivityStatus.completed, ActivityStatus.ongoing],
          startTime: startTime,
        ));

    DataLog accountData = arrangeMonthlyDataLog(
        timeNow: DateTime(timeNow.year - 1, 12), data: accountRes);

    DataLog organizationData = arrangeMonthlyDataLog(
        timeNow: DateTime(timeNow.year - 1, 12), data: organizationRes);

    DataLog activityData = arrangeMonthlyDataLog(
        timeNow: DateTime(timeNow.year - 1, 12), data: activityRes);

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  Future<AdminChartDataModel> _getAllTime() async {
    final timeNow = DateTime.now();
    final accountRes = await ref.watch(accountServiceProvider).getLog();
    final organizationRes = await ref
        .watch(adminOrganizationServiceProvider)
        .getLog(
            query: OrganizationLogQuery(status: OrganizationStatus.verified));
    final activityRes = await ref.watch(activityServiceProvider).getLog(
            query: ActivityLogQuery(
          status: [ActivityStatus.completed, ActivityStatus.ongoing],
        ));

    int timeMin = timeNow.year;
    for (var i
        in (accountRes.yearly + organizationRes.yearly + activityRes.yearly)) {
      if (i.year < timeMin) {
        timeMin = i.year;
      }
    }

    final accountData = arrangeYearlyDataLog(
        data: accountRes, timeNow: timeNow, timeMin: timeMin);

    final organizationData = arrangeYearlyDataLog(
        data: organizationRes, timeNow: timeNow, timeMin: timeMin);

    final activityData = arrangeYearlyDataLog(
        data: activityRes, timeNow: timeNow, timeMin: timeMin);

    return AdminChartDataModel(
        account: accountData,
        organization: organizationData,
        activity: activityData);
  }

  DataLog arrangeMonthlyDataLog({
    required DateTime timeNow,
    required DataLog data,
  }) {
    DataLog filtereddData = data.copyWith(
        monthly: data.monthly.filter((t) => t.year == timeNow.year).toList());

    DataLog dummyLog = DataLog(total: 0, monthly: [
      for (var i = timeNow.month; i > 0; i--)
        DataMonthlyLog(month: i, year: timeNow.year)
    ]);

    List<DataMonthlyLog> newList = filtereddData.monthly +
        dummyLog.monthly
            .where(
                (a) => filtereddData.monthly.every((b) => a.month != b.month))
            .toList();

    newList.sort(((a, b) => a.month.compareTo(b.month)));

    return filtereddData.copyWith(monthly: newList);
  }

  DataLog arrangeYearlyDataLog({
    required DateTime timeNow,
    required DataLog data,
    required int timeMin,
  }) {
    DataLog dummyLog = DataLog(total: 0, yearly: [
      for (var i = timeNow.year; i >= timeMin; i--) DataYearlyLog(year: i)
    ]);

    List<DataYearlyLog> newList = data.yearly +
        dummyLog.yearly
            .where((a) => data.yearly.every((b) => a.year != b.year))
            .toList();

    newList.sort(((a, b) => a.year.compareTo(b.year)));

    return data.copyWith(yearly: newList);
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
    List<ActivityAnalyticModel> tempList0 = [];
    List<ActivityAnalyticModel> tempList1 = [];
    const query = RankQuery();

    final accountData = filter == 0
        ? await adminRankingRepo.getAccountsRank(query: query)
        : null;
    final organizationData = filter == 1
        ? await adminRankingRepo.getOrganizationsRank(query: query)
        : null;
    List<ActivityAnalyticModel> activityDataByJoined = filter == 2
        ? await adminRankingRepo.getActivitiesRankByJoined(query: query)
        : [];
    List<ActivityAnalyticModel> activityDataByRating = filter == 3
        ? await adminRankingRepo.getActivitiesRankByRating(query: query)
        : [];

    for (var i in activityDataByJoined) {
      final orgData = (await ref
          .watch(organizationRepositoryProvider)
          .getById(i.organizationId!))!;
      tempList0.add(i.copyWith(
          organizationLogo: orgData.logo, organizationName: orgData.name));
    }

    activityDataByJoined = tempList0;

    for (var i in activityDataByRating) {
      final orgData = (await ref
          .watch(organizationRepositoryProvider)
          .getById(i.organizationId!))!;
      tempList1.add(i.copyWith(
          organizationLogo: orgData.logo, organizationName: orgData.name));
    }
    activityDataByRating = tempList1;

    return AdminRankingDataModel(
        account: accountData,
        organization: organizationData,
        activityByJoined: activityDataByJoined,
        activityByRating: activityDataByRating);
  }
}
