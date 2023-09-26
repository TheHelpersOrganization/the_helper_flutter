import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:the_helper/src/common/widget/file_picker/form_multiple_file_picker_field.dart';

final organizationRegistrationStepFileFormKey = GlobalKey<FormBuilderState>();

class OrganizationRegistrationStepFile extends StatelessWidget {
  const OrganizationRegistrationStepFile({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: organizationRegistrationStepFileFormKey,
      child: Column(
        children: [
          FormMultipleFilePickerField(name: 'files'),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
