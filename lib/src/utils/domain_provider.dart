import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domain_provider.g.dart';

@riverpod
String baseUrl(ref) {
  return domain;
}

String getImageUrl(int id) => '$domain/files/public/image/i/$id';

// const String baseDomain = '34.82.74.166';
// const String basePort = '3000';

const String baseDomain = 'thehelpers.azurewebsites.net';
const String basePort = '80';
const String basePrefix = 'api/v1';
const String domain = 'http://$baseDomain:$basePort/$basePrefix';
