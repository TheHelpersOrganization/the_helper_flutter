import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';

import '../../../../common/widget/button/primary_button.dart';
import '../../domain/profile.dart';
import 'edit_profile_avatar_picker_widget.dart';
import 'edit_profile_controller.dart';
import 'edit_profile_gender_widget.dart';
import 'edit_profile_phone_number_widget.dart';

// import '../../../common/widget/button/primary_button.dart';
// import '../domain/profile.dart';

class EditProfileScreen extends ConsumerWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editProfileController =
        ref.watch(editProfileControllerProvider.notifier);
    final editProfileControllerState = ref.watch(editProfileControllerProvider);
    final profile = editProfileControllerState;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: profile.when(
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (profile) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                const EditProfileAvatarPickerWidget(),
                const SizedBox(
                  height: 16,
                ),
                FormBuilderTextField(
                  name: 'username',
                  initialValue: profile.username,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter username. e.g Cool-combatant_0',
                    labelText: 'Username',
                  ),
                  validator:
                      FormBuilderValidators.match(r'^[A-Za-z0-9_-]{5,20}$'),
                ),
                FormBuilderTextField(
                  name: 'firstName',
                  initialValue: profile.firstName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your first name',
                    labelText: 'First Name',
                  ),
                ),
                FormBuilderTextField(
                  name: 'lastName',
                  initialValue: profile.lastName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your last name',
                    labelText: 'Last Name',
                  ),
                ),
                FormBuilderTextField(
                  name: 'bio',
                  initialValue: profile.bio,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  validator: FormBuilderValidators.maxLength(200),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bio',
                    hintText: 'Write something about you',
                  ),
                ),
                FormBuilderField(
                    name: 'gender',
                    initialValue: profile.gender,
                    builder: (FormFieldState<dynamic> field) {
                      return EditProfileGenderWidget(
                          initialValue: profile.gender,
                          onValueChange: (gender) => {
                                field.didChange(gender),
                              });
                    }),
                FormBuilderDateTimePicker(
                  inputType: InputType.date,
                  initialValue: profile.dateOfBirth,
                  format: DateFormat('yyyy-MM-dd'),
                  name: 'dateOfBirth',
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your date of birth',
                    labelText: 'Date Of Birth',
                  ),
                ),
                EditProfilePhoneNumberWidget(
                  initialValue: profile.phoneNumber,
                ),
                // FormBuilderTextField(
                //   name: 'addressLine1',
                //   initialValue: profile.addressLine1,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Enter your street name',
                //     labelText: 'Address Line 1',
                //   ),
                // ),
                // FormBuilderTextField(
                //   name: 'addressLine2',
                //   initialValue: profile.addressLine2,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Enter your district, city',
                //     labelText: 'Address Line 2',
                //   ),
                // ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: OutlinedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              _formKey.currentState!.reset();
                            })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        isLoading: editProfileControllerState.isLoading,
                        onPressed: () {
                          _formKey.currentState!.save();
                          // Validate returns true if the form is valid, or false otherwise.
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          final value = _formKey.currentState!.value;
                          final profile = Profile.fromJson(value);
                          editProfileController.updateProfile(profile);
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ].padding(const EdgeInsets.symmetric(vertical: 12))),
            ),
          ),
        ));
  }
}
