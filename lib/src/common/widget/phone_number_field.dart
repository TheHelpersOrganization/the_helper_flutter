import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../constant/regex.dart';

class PhoneNumberField extends StatelessWidget {
  final String? initialValue;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;

  const PhoneNumberField({
    super.key,
    this.initialValue,
    this.decoration,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderPhoneField(
      name: 'phoneNumber',
      initialValue: initialValue,
      decoration: decoration ??
          const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'eg. 0999123456',
            labelText: 'Phone Number',
          ),
      keyboardType: TextInputType.phone,
      defaultSelectedCountryIsoCode: 'VN',
      countryFilterByIsoCode: const ['VN', 'US'],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: FormBuilderValidators.compose(
        [
          if (validator != null) validator!,
          FormBuilderValidators.match(
            phoneNumberRegex,
            errorText: 'Invalid phone number',
          ),
        ],
      ),
      valueTransformer: (value) {
        print(value);
      },
      onFieldSubmitted: (v) {
        print(v);
      },
    );
  }
}
