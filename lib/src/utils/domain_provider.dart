import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domain_provider.g.dart';

@riverpod
String baseUrl(ref) {
  return domain;
}

@riverpod
String baseWsUrl(ref) {
  return 'ws://$baseDomain:$basePort';
}

String getImageUrl(int id) => '$domain/files/public/image/i/$id';

const String baseDomain = 'thehelpers.me';
const String basePort = '3000';
// const String baseDomain = 'localhost';
// const String basePort = '3000';

const String basePrefix = 'api/v1';
const String domain = 'http://$baseDomain:$basePort/$basePrefix';
