import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormFieldCountryPicker extends StatefulWidget {
  final Function(Country country)? onSelect;
  final InputDecoration? decoration;
  final String name;
  final String? Function(String?)? validator;

  const FormFieldCountryPicker({
    super.key,
    this.name = 'country',
    this.onSelect,
    this.validator,
    this.decoration,
  });

  @override
  State<FormFieldCountryPicker> createState() => _FormFieldCountryPickerState();
}

class _FormFieldCountryPickerState extends State<FormFieldCountryPicker> {
  final _controller = TextEditingController();
  Country? _country;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      controller: _controller,
      onTap: () => showCountryPicker(
        context: context,
        onSelect: (country) {
          _controller.text = country.name;
          setState(() {
            _country = country;
          });
        },
      ),
      readOnly: true,
      validator: widget.validator,
      decoration: widget.decoration ?? const InputDecoration(),
      valueTransformer: (value) => _country,
    );
  }
}
