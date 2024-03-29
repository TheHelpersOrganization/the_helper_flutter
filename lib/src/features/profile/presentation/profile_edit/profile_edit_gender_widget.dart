import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';

import '../../../../common/widget/radio/app_radio_grouped_button.dart';
import '../../domain/gender.dart';

class ProfileEditGenderWidget extends ConsumerWidget {
  final String? initialValue;
  final Function(String) onValueChange;

  const ProfileEditGenderWidget(
      {super.key, required this.onValueChange, this.initialValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            color: context.theme.inputDecorationTheme.labelStyle?.color,
          ),
        ),
        AppRadioButtonGroup<String>(
          width: context.mediaQuery.size.width * 0.23,
          enableShape: true,
          elevation: 0,
          buttonLabels: const [
            'Male',
            'Female',
            'Other',
          ],
          buttonValues: [
            Gender.male.name,
            Gender.female.name,
            Gender.other.name,
          ],
          buttonTextStyle: const ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(fontSize: 16)),
          padding: 8,
          unSelectedColor: Theme.of(context).canvasColor,
          unSelectedBorderColor: context.theme.disabledColor,
          selectedColor: Theme.of(context).primaryColor,
          defaultSelected: initialValue,
          onValueChange: onValueChange,
        ),
      ].padding(const EdgeInsets.all(16), ignoreFirst: true),
    );
  }
}
