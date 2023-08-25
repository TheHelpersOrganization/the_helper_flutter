import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/validator/validator.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/controller/reset_password_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resetPasswordState = ref.watch(resetPasswordControllerProvider);
    final email = ref.watch(emailTextEditingControllerProvider).text;
    final token = ref.watch(otpTextEditingControllerProvider).text;
    final passwordTextEditingController =
        ref.watch(passwordTextEditingControllerProvider);
    final hidePassword = ref.watch(hidePasswordProvider);

    ref.listen(resetPasswordControllerProvider, (previous, next) {
      next.showSnackbarOnError(context);
    });

    return LoadingOverlay.customDarken(
      isLoading: resetPasswordState.isLoading,
      indicator: const LoadingDialog(titleText: 'Changing Password'),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your new password.',
                ),
                const SizedBox(height: 24),
                FormBuilderTextField(
                  name: 'password',
                  controller: passwordTextEditingController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(hidePasswordProvider.notifier).state =
                            !hidePassword;
                      },
                      icon: const Icon(
                        Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  obscureText: hidePassword,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 24),
                FormBuilderTextField(
                  name: 'confirmPassword',
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm New Password',
                    hintText: 'Enter your new password again',
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(hidePasswordProvider.notifier).state =
                            !hidePassword;
                      },
                      icon: const Icon(
                        Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  obscureText: hidePassword,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.equal(
                        passwordTextEditingController.text,
                        errorText: 'Passwords do not match',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.saveAndValidate()) {
                      return;
                    }
                    final String password =
                        formKey.currentState!.fields['password']?.value;

                    ref
                        .read(resetPasswordControllerProvider.notifier)
                        .resetPassword(
                          email: email,
                          token: token,
                          password: password,
                        );
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
