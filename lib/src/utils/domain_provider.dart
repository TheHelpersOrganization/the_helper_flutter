import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domain_provider.g.dart';

@riverpod
String baseUrl(BaseUrlRef ref) {
  const String baseDomain = '34.82.74.166';
  const String basePort = '3000';
  const String basePrefix = 'api/v1';
  return 'http://$baseDomain:$basePort/$basePrefix';
}
