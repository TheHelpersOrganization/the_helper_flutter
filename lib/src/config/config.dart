// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:envied/envied.dart';

part 'config.g.dart';

enum AppEnvironment {
  development,
  production,
  ;

  bool isDevelopment() => this == AppEnvironment.development;

  bool isProduction() => this == AppEnvironment.production;
}

@Envied(path: '.env', obfuscate: true)
abstract class AppEnv {
  @EnviedField(defaultValue: 'development')
  static final String APP_ENV = _AppEnv.APP_ENV;
}

abstract class AppConfig {
  static final appEnv = AppEnvironment.values.firstWhere(
    (e) => e.name == AppEnv.APP_ENV,
  );
  static final isDevelopment = appEnv.isDevelopment();
  static final isProduction = appEnv.isProduction();
}
