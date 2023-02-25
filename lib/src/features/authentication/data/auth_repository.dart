import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/domain/app_user.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/in_memory_store.dart';
import 'package:dio/dio.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/domain/token.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/dio_provider.dart';

import '../../../utils/domain_provider.dart';

class AuthRepository {
  AuthRepository({
    required this.client,
    required this.url,
  });
  final Dio client;
  final String url;
  // AppUser? get userId 
  final _authState = InMemoryStore<AppUser?>(null);
  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;
  // Future<void> signInAnonymously() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   // final response = await client.post(
  //   // '$baseUrl/auth/login',
  //   // data: {"email": "hello@hello.com", "password": "123456"},
  //   // );

  //   _authState.value = const AppUser(
  //     email: "guest",
  //     token: null,
  //   );
  // }

  Future<void> signIn(String email, String password) async {
    final response = await client.post(
      '$url/auth/login',
      data: {
        "email": email,
        "password": password,
      },
    );
    _authState.value = AppUser(
      email: email,
      token: Token.fromJson(response.data['data']),
    );
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository(
    client: ref.read(dioProvider),
    url: ref.read(baseUrlProvider),
  );
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
