import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../common/constant/regex.dart';
import '../../domain/profile.dart';
import '../profile_controller.dart';
import 'profile_edit_controller.dart';
import 'profile_edit_gender_widget.dart';

class ProfileEditBasicInfoWidget extends ConsumerWidget {
  final Profile profile;
  final GlobalKey<FormBuilderState> formKey;

  const ProfileEditBasicInfoWidget({
    super.key,
    required this.profile,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basicInfoChange = ref.watch(basicInfoValurChangeProvider);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Basic info',
                style: context.theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            basicInfoChange
                ? TextButton.icon(
                    onPressed: () {
                      formKey.currentState!.save();
                      // Validate returns true if the form is valid, or false otherwise.
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final value = formKey.currentState!.value;
                      final newValue = {
                        ...value,
                        'dateOfBirth': (value['dateOfBirth'] as DateTime)
                            .toUtc()
                            .toIso8601String(),
                      };
                      final profile = Profile.fromJson(newValue);
                      ref
                          .read(profileControllerProvider().notifier)
                          .updateProfile(profile);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Save change'),
                  )
                : const SizedBox(),
          ],
        ),
        FormBuilderTextField(
          name: 'username',
          initialValue: profile.username,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter username. e.g Cool-combatant_0',
            labelText: 'Username',
          ),
          validator: FormBuilderValidators.match(r'^[A-Za-z0-9_-]{5,20}$'),
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
        ),
        FormBuilderTextField(
          name: 'firstName',
          initialValue: profile.firstName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your first name',
            labelText: 'First Name',
          ),
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
        ),
        FormBuilderTextField(
          name: 'lastName',
          initialValue: profile.lastName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your last name',
            labelText: 'Last Name',
          ),
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
        ),
        FormBuilderField(
            name: 'gender',
            initialValue: profile.gender,
            onChanged: (value) {
              ref.read(basicInfoValurChangeProvider.notifier).state = true;
            },
            builder: (FormFieldState<dynamic> field) {
              return ProfileEditGenderWidget(
                  initialValue: profile.gender,
                  onValueChange: (gender) => {
                        field.didChange(gender),
                      });
            }),
        FormBuilderDateTimePicker(
          inputType: InputType.date,
          initialValue: profile.dateOfBirth?.toLocal(),
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
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
        ),
        FormBuilderPhoneField(
          name: 'phoneNumber',
          initialValue: profile.phoneNumber,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'eg. 0999123456',
            labelText: 'Phone Number',
          ),
          keyboardType: TextInputType.phone,
          defaultSelectedCountryIsoCode: 'VN',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: FormBuilderValidators.match(phoneNumberRegex,
              errorText: 'Not a valid phone number'),
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
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
          onChanged: (value) {
            ref.read(basicInfoValurChangeProvider.notifier).state = true;
          },
        ),
      ],
    );
  }
}
