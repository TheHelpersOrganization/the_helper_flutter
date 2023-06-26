import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/organization.dart';
import '../domain/organization_query.dart';

part 'organization_service.g.dart';

class OrganizationService {
  final Dio client;
  final OrganizationRepository organizationRepository;

  const OrganizationService({
    required this.client,
    required this.organizationRepository,
  });

  Future<List<Organization>> getAll({
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Organization.fromJson(e)).toList();
  }

  Future<int> getCount({
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Organization.fromJson(e)).toList().length;
  }

  Future<int> getRequestCount({
    OrganizationQuery? query,
  }) async {
    // final List<dynamic> res = (await client.get(
    //   '/organizations',
    //   queryParameters: query?.toJson(),
    // ))
    //     .data['data'];
    // return res.map((e) => Organization.fromJson(e)).toList().length;
    return 5;
  }
}

@riverpod
OrganizationService organizationService(OrganizationServiceRef ref) {
  return OrganizationService(
    client: ref.watch(dioProvider),
    organizationRepository: ref.watch(organizationRepositoryProvider),
  );
}
