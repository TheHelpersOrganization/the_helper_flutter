import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'inline_editable_text.dart';

class FormBuilderInlineEditableText extends StatelessWidget {
  final String name;
  final FormFieldValidator? validator;
  final String initialValue;
  final TextStyle? style;
  final bool showEditButton;

  const FormBuilderInlineEditableText({
    super.key,
    required this.name,
    this.validator,
    required this.initialValue,
    required this.style,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      validator: validator,
      initialValue: initialValue,
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            errorText: field.errorText,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          child: InlineEditableText(
            initialValue: initialValue,
            style: style,
            showEditButton: showEditButton,
            onChanged: (value) {
              field.didChange(value);
            },
          ),
        );
      },
    );
  }
}
