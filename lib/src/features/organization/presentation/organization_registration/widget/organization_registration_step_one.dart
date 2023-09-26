import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/phone_number_field.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/config/config.dart';

final organizationRegistrationStepOneFormKey = GlobalKey<FormBuilderState>();

class OrganizationRegistrationStepOne extends StatelessWidget {
  const OrganizationRegistrationStepOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: organizationRegistrationStepOneFormKey,
        child: Column(
            children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g Volunteer-organization_0',
              label: RequiredText('Name'),
              helperText: 'Can contain letter, number, spaces, - and _',
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.match(
                RegExp(r'^[\w,.0-9\s-]+$').pattern,
                errorText: 'Can only contain letters, numbers, spaces, - and _',
              ),
            ]),
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g name@organization.com',
              label: RequiredText('Email'),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
          PhoneNumberField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g 0 123 456 7890',
              label: RequiredText('Phone Number'),
            ),
            validator: FormBuilderValidators.required(),
          ),
          FormBuilderTextField(
            name: 'website',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g www.your-organization.com',
              label: RequiredText('Website'),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.url(),
            ]),
          ),
          FormBuilderTextField(
            name: 'description',
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: null,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(200),
            ]),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: RequiredText('Description'),
              hintText: 'Write about what your organization does',
            ),
          ),
          const SizedBox(height: 16),
          if (AppConfig.isDevelopment)
            Column(
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    final fields = organizationRegistrationStepOneFormKey
                        .currentState!.fields;
                    fields['name']!.didChange('Test');
                    fields['email']!.didChange('test@org.com');
                    fields['phoneNumber']!.didChange('+84339049688');
                    fields['website']!.didChange('www.test.com');
                    fields['description']!.didChange('Test description');
                  },
                  label: const Text('Fill Test Data'),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
        ].sizedBoxSpacing(const SizedBox(
          height: 12,
        ))),
      ),
    );
  }
}
