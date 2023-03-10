import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/app_bar/app_bar.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/button/primary_button.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/edit_profile_avatar_picker_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/edit_profile_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/edit_profile_dob_picker_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/edit_profile_gender_widget.dart';

class EditProfileScreen extends ConsumerWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailInputController = ref.watch(emailInputControllerProvider);
    final firstNameInputController =
        ref.watch(firstNameFieldControllerProvider);
    final usernameInputController = ref.watch(usernameFieldControllerProvider);
    final lastNameInputController = ref.watch(lastNameFieldControllerProvider);
    final bioInputController = ref.watch(bioFieldControllerProvider);
    final dateInputController = ref.watch(dateInputControllerProvider);
    final genderSelection = ref.watch(genderInputSelectionProvider);
    final phoneNumberController = ref.watch(phoneNumberInputControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
            const EditProfileAvatarPickerWidget(),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: emailInputController,
              enabled: false,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
            TextFormField(
              controller: usernameInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter username',
                labelText: 'Username',
              ),
              validator:
                  FormBuilderValidators.match(r'/^[A-Za-z0-9_-]{5,20}$/'),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: firstNameInputController,
              validator: FormBuilderValidators.email(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter first name',
                labelText: 'First Name',
              ),
            ),
            TextFormField(
              controller: lastNameInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter last name',
                labelText: 'Last Name',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
              controller: bioInputController,
              validator: FormBuilderValidators.maxLength(200),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter bio',
                labelText: 'Write something about you',
              ),
            ),
            const EditProfileGenderWidget(),
            const EditProfileDobPickerWidget(),
            FormBuilderPhoneField(
              name: 'phone_number',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'eg. 0339049688',
                labelText: 'Phone Number',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.match(
                    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
                    errorText: 'Not a valid phone number'),
              ]),
              onChanged: (v) => print(v),
            ),
            PrimaryButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ].padding(const EdgeInsets.symmetric(vertical: 8))),
        ),
      ),
    );
  }
}
