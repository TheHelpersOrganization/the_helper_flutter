import 'package:simple_auth_flutter_riverpod/src/features/authentication/domain/token.dart';

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.email,
    this.token,
  });
  final String email;
  final Token? token;
}
