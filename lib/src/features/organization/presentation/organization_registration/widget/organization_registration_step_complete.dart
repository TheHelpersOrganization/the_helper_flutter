import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class OrganizationRegistrationStepComplete extends StatelessWidget {
  const OrganizationRegistrationStepComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            'You may want to review your information before submitting.'),
        Text.rich(
          TextSpan(
            text: 'After review, please click ',
            children: [
              TextSpan(
                text: 'Submit',
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' to finish the registration.'),
            ],
          ),
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}
