class Token {
  final String access;
  final String refresh;
  Token({
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
}
