import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'edit_profile_controller.dart';

class EditProfileDobPickerWidget extends ConsumerWidget {
  const EditProfileDobPickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateInputController = ref.watch(dateInputControllerProvider);

    return TextFormField(
      controller: dateInputController,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
        hintText: 'Enter your date of birth',
        labelText: 'Date Of Birth',
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now());
        if (pickedDate == null) {
          return;
        }
        String dateString = DateFormat('yyyy-MM-dd').format(pickedDate);
        dateInputController.text = dateString;
      },
    );
  }
}
