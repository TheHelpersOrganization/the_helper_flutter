import 'package:dio/dio.dart';
import 'package:the_helper/src/utils/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/account_analytic_model.dart';
import '../domain/activity_analytic_model.dart';
import '../domain/organization_analytic_model.dart';
import '../domain/rank_query.dart';

part 'analytic_repository.g.dart';

class AdminAnalyticRepository {
  final Dio client;

  AdminAnalyticRepository({
    required this.client,
  });

  Future<List<AccountAnalyticModel>> getAccountsRank({
    RankQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/analytics/rankings/accounts',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AccountAnalyticModel.fromJson(e)).toList();
  }

  Future<List<OrganizationAnalyticModel>> getOrganizationsRank({
    RankQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/analytics/rankings/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => OrganizationAnalyticModel.fromJson(e)).toList();
  }

  Future<List<ActivityAnalyticModel>> getActivitiesRank({
    RankQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/analytics/rankings/activities',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => ActivityAnalyticModel.fromJson(e)).toList();
  }
}

@riverpod
AdminAnalyticRepository adminAnalyticRepository(
        AdminAnalyticRepositoryRef ref) =>
    AdminAnalyticRepository(client: ref.watch(dioProvider));
