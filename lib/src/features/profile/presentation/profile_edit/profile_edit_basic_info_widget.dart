import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:the_helper/src/common/extension/widget.dart';

import '../../domain/profile.dart';
import '../profile_controller.dart';
import 'profile_edit_controller.dart';
import 'profile_edit_gender_widget.dart';

class ProfileEditBasicInfoWidget extends ConsumerStatefulWidget {
  final Profile profile;
  final GlobalKey<FormBuilderState> formKey;

  const ProfileEditBasicInfoWidget({
    super.key,
    required this.profile,
    required this.formKey,
  });

  @override
  ConsumerState<ProfileEditBasicInfoWidget> createState() =>
      _ProfileEditBasicInfoWidgetState();
}

class _ProfileEditBasicInfoWidgetState
    extends ConsumerState<ProfileEditBasicInfoWidget> {
  late PhoneController phoneController = PhoneController(
      widget.profile.phoneNumber != null
          ? PhoneNumber.parse(widget.profile.phoneNumber!)
          : null);

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final basicInfoChange = ref.watch(basicInfoValurChangeProvider);
    final formKey = widget.formKey;
    final profile = widget.profile;
    return Column(
      children: <Widget>[
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
                        // 2134435742
                        return;
                      }
                      final value = formKey.currentState!.value;
                      final newValue = {
                        ...value,
                        'dateOfBirth': (value['dateOfBirth'] as DateTime)
                            .toUtc()
                            .toIso8601String(),
                        'phoneNumber': phoneController.value?.international,
                      };
                      // print(newValue);

                      final newProfile = Profile.fromJson(newValue);
                      ref
                          .read(profileControllerProvider().notifier)
                          .updateProfile(newProfile);
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
        PhoneFormField(
          controller: phoneController,
          defaultCountry: IsoCode.VN,
          isCountryChipPersistent: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Phone number'),
            hintText: 'Enter phone number',
          ),
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
      ].padding(const EdgeInsets.symmetric(vertical: 12)),
    );
  }
}
