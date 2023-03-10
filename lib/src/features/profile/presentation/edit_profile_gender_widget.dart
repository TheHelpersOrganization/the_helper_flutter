import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';

import '../../../common/widget/radio/app_radio_grouped_button.dart';
import 'edit_profile_controller.dart';

class EditProfileGenderWidget extends ConsumerWidget {
  const EditProfileGenderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genderSelection = ref.watch(genderInputSelectionProvider);

    return Row(
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16),
        ),
        AppRadioButtonGroup(
          width: context.mediaQuery.size.width * 0.2,
          enableShape: true,
          elevation: 0,
          buttonLabels: const [
            'Male',
            'Female',
            'Other',
          ],
          buttonValues: const [
            Gender.male,
            Gender.female,
            Gender.other,
          ],
          buttonTextStyle: const ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(fontSize: 16)),
          padding: 8,
          unSelectedColor: Theme.of(context).canvasColor,
          unSelectedBorderColor: context.theme.disabledColor,
          selectedColor: Theme.of(context).primaryColor,
          defaultSelected: genderSelection,
          onValueChange: (Gender value) {
            ref.read(genderInputSelectionProvider.notifier).state = value;
          },
        ),
      ].padding(const EdgeInsets.all(16), ignoreFirst: true),
    );
  }
}
