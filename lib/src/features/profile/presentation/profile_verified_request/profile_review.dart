import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/widget.dart';

import '../../domain/profile.dart';
import '../profile_edit/profile_edit_gender_widget.dart';
import '../profile_edit/profile_edit_phone_number_widget.dart';
import 'profile_avatar_watcher_widget.dart';

// import '../../../common/widget/button/primary_button.dart';
// import '../domain/profile.dart';

class ProfileReviewWidget extends StatelessWidget {
  const ProfileReviewWidget({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      onChanged: () {},
      child: Column(
        children: <Widget>[
        const ProfileAvatarWatcherWidget(),
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
              return ProfileEditGenderWidget(
                  initialValue: profile.gender,
                  onValueChange: (gender) => {
                        // field.didChange(gender),
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
        ),
        ProfileEditPhoneNumberWidget(
          initialValue: profile.phoneNumber,
        ),
      ].padding(const EdgeInsets.symmetric(vertical: 12))),
    );
  }
}