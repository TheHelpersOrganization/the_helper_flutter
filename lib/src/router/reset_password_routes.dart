import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/screen/reset_password_screen.dart';
import 'package:the_helper/src/router/router.dart';

final resetPasswordRoutes = GoRoute(
  path: AppRoute.resetPassword.path,
  name: AppRoute.resetPassword.name,
  builder: (context, state) {
    return const ResetPasswordScreen();
  },
);
