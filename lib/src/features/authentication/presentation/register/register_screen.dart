import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/authentication/presentation/register/register_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:the_helper/src/features/authentication/presentation/login_controller.dart';
// import 'package:the_helper/src/utils/async_value_ui.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // RegisterScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      registerControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final state = ref.watch(registerControllerProvider);
    final passwordVisible = ref.watch(passwordVisibilityProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                      'Sign up your account',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: emailController,
                      onFieldSubmitted: (e) {
                        ref.read(registerControllerProvider.notifier).register(
                              emailController.text,
                              passwordController.text,
                            );
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.mail),
                        hintText: 'Enter email. e.g. abc@gmail.com',
                        labelText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: passwordVisible,
                      autocorrect: false,
                      enableSuggestions: false,
                      onFieldSubmitted: (e) {
                        ref.read(registerControllerProvider.notifier).register(
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
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.key),
                        hintText: 'Enter password',
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: repasswordController,
                      obscureText: passwordVisible,
                      autocorrect: false,
                      enableSuggestions: false,
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
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.key),
                        hintText: 'Re-enter password',
                        labelText: 'Re-enter password',
                      ),
                      validator: (String? value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: PrimaryButton(
                            child: const Text('Sign Up'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(registerControllerProvider.notifier)
                                    .register(emailController.text,
                                        passwordController.text);
                              }
                            },
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
                              Navigator.pop(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => RegisterScreen()),
                              // );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('Back to Sign In'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState!.validate()) {
                  //         ref
                  //             .read(registerControllerProvider.notifier)
                  //             .register(emailController.text,
                  //                 passwordController.text);
                  //       }
                  //       // _formKey.currentState.save();
                  //       // if (_formKey.currentState.validate()) {}
                  //     },
                  //     child: const Text('Register'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
