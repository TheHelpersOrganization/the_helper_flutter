import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';

import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:intl/intl.dart';
import 'package:the_helper/src/common/constant/regex.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/extension/widget.dart';

import '../../domain/profile.dart';
import '../profile_edit/profile_edit_gender_widget.dart';

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
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              width: 8,
              color: Theme.of(context).primaryColor,
            ),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: profile.avatarId == null
                  ? Image.asset(
                      'assets/images/organization_placeholder.jpg',
                    ).image
                  : ImageX.backend(
                      profile.avatarId!,
                    ).image,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
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
          validator: FormBuilderValidators.match(r'^[A-Za-z0-9_-]{5,20}$'),
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
        ),
      ].padding(const EdgeInsets.symmetric(vertical: 12))),
    );
  }
}
