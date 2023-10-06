import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/config/config.dart';
import 'package:the_helper/src/features/authentication/presentation/login_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      loginControllerProvider,
      (err, state) => state.showSnackbarOnError(context),
    );
    final state = ref.watch(loginControllerProvider);
    final passwordVisible = ref.watch(passwordVisibilityProvider);

    final volunteerIdTextEditingController =
        ref.watch(volunteerIdTextEditingControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign in to your account',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: emailController,
                        onFieldSubmitted: (e) {
                          ref.read(loginControllerProvider.notifier).signIn(
                                emailController.text,
                                passwordController.text,
                              );
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                          hintText: 'Enter email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        obscureText: passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        onFieldSubmitted: (e) {
                          ref.read(loginControllerProvider.notifier).signIn(
                                emailController.text,
                                passwordController.text,
                              );
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(passwordVisibilityProvider.notifier)
                                  .state = !passwordVisible;
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.key),
                          border: const OutlineInputBorder(),
                          hintText: 'Enter password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context.goNamed(AppRoute.resetPassword.name);
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: PrimaryButton(
                              isLoading: false,
                              loadingText: "Logging in...",
                              onPressed: () {
                                ref
                                    .read(loginControllerProvider.notifier)
                                    .signIn(
                                      emailController.text,
                                      passwordController.text,
                                    );
                              },
                              child: const Text('Sign In'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(
                                    0, context.mediaQuery.size.height * 0.06),
                              ),
                              onPressed: () {
                                context.goNamed(AppRoute.register.name);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('Sign Up Now'),
                              ),
                            ),
                          ),
                          if (AppConfig.isDevelopment && false) ...[
                            const SizedBox(
                              height: 24,
                            ),
                            const Row(
                              children: <Widget>[
                                Expanded(child: Divider()),
                                Text("Development Only"),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PrimaryButton(
                                isLoading: false,
                                loadingText: "Logging in...",
                                onPressed: () {
                                  ref
                                      .read(loginControllerProvider.notifier)
                                      .signIn(
                                        "hquan310@gmail.com",
                                        "123456",
                                      );
                                },
                                child: const Text('Login with Default Account'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PrimaryButton(
                                    isLoading: false,
                                    loadingText: "Logging in...",
                                    onPressed: () {
                                      final volunteerId =
                                          volunteerIdTextEditingController.text
                                              .trim();
                                      ref
                                          .read(
                                              loginControllerProvider.notifier)
                                          .signIn(
                                            'volunteer$volunteerId@thehelpers.me',
                                            "123456",
                                          );
                                    },
                                    child: const Text('Login as Volunteer'),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: FormBuilderTextField(
                                      name: 'volunteerId',
                                      controller:
                                          volunteerIdTextEditingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        hintText: 'Enter volunteer id',
                                      ),
                                      validator:
                                          FormBuilderValidators.integer(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
