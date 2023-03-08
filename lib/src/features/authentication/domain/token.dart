import 'package:flutter/foundation.dart';

@immutable
class Token {
  final String access;
  final String refresh;

  const Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> data) {
    final access = data['accessToken'] as String;
    final refresh = data['refreshToken'] as String;
    return Token(
      access: access,
      refresh: refresh,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          runtimeType == other.runtimeType &&
          access == other.access &&
          refresh == other.refresh;

  @override
  int get hashCode => access.hashCode ^ refresh.hashCode;

  @override
  String toString() {
    return 'Token{access: $access, refresh: $refresh}';
  }
}
