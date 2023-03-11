import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../common/constant/regex.dart';

class EditProfilePhoneNumberWidget extends ConsumerWidget {
  final String? initialValue;

  const EditProfilePhoneNumberWidget({
    super.key,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderPhoneField(
      name: 'phoneNumber',
      initialValue: initialValue,
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
    );
  }
}
