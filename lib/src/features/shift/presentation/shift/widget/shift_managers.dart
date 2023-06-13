import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift_manager.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ShiftManagers extends StatelessWidget {
  final List<ShiftManager>? managers;

  const ShiftManagers({
    super.key,
    required this.managers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Managers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        if (managers?.isNotEmpty != true)
          Text(
            'No manager found',
            style: TextStyle(color: context.theme.colorScheme.secondary),
          )
        else
          Column(
            children: managers!.map((manager) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(getProfileName(manager.profile)),
                leading: CircleAvatar(
                  backgroundImage: getBackendImageOrLogoProvider(
                    manager.profile?.avatarId,
                  ),
                ),
                minVerticalPadding: 16,
              );
            }).toList(),
          ),
      ],
    );
  }
}
