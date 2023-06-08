import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ActivityManagers extends StatelessWidget {
  final List<int>? managers;
  final List<Profile>? profiles;

  const ActivityManagers({
    super.key,
    required this.managers,
    required this.profiles,
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
              final profile = profiles!.firstWhereOrNull(
                (p) => p.id == manager,
              );
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(getProfileName(profile)),
                leading: CircleAvatar(
                  backgroundImage:
                      getBackendImageOrLogoProvider(profile?.avatarId),
                ),
                minVerticalPadding: 16,
              );
            }).toList(),
          ),
      ],
    );
  }
}
