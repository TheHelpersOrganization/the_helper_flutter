import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_list_size.g.dart';

@riverpod
int fetchListSize(FetchListSizeRef ref) {
  return 20;
}