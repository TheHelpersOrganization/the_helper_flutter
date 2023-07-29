import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/authentication/presentation/login_controller.dart';
import 'package:the_helper/src/features/authentication/presentation/register/register_screen.dart';
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      onFieldSubmitted: (e) {
                        ref.read(loginControllerProvider.notifier).signIn(
                              emailController.text,
                              passwordController.text,
                            );
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                        hintText: 'Enter password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
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
                              ref.read(loginControllerProvider.notifier).signIn(
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('Register'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: PrimaryButton(
                            isLoading: false,
                            loadingText: "Logging in...",
                            onPressed: () {
                              ref.read(loginControllerProvider.notifier).signIn(
                                    "hquan310@gmail.com",
                                    "123456",
                                  );
                            },
                            child: const Text('Tester login...'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
