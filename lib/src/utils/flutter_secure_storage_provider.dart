import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flutter_secure_storage_provider.g.dart';

// final secureStorageProvider =
//     Provider((ref) => const FlutterSecureStorage());

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}
