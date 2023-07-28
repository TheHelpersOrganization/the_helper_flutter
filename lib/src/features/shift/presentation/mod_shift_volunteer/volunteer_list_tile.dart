import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

class VolunteerListTile extends ConsumerWidget {
  final Profile profile;
  const VolunteerListTile({
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: CheckboxListTile(
        isThreeLine: true,
        title: Text('${profile.firstName!} ${profile.lastName!}'),
        subtitle: SizedBox(
          height: 48.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...profile.skills
                  .map(
                    (skill) => Chip(
                      labelPadding: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      avatar: const Icon(Icons.wb_sunny_outlined),
                      label: Text('${skill.name} - ${skill.hours}'),
                    ),
                  )
                  .toList(),
            ].sizedBoxSpacing(
              const SizedBox(
                width: 8.0,
              ),
            ),
          ),
        ),
        secondary: CircleAvatar(
          radius: 24,
          backgroundImage: 
          profile.avatarId == null
          ? Image.asset('assets/images/logo.png').image
          :ImageX.backend(
            profile.avatarId!,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const CircularProgressIndicator(),
          ).image,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        onChanged: (bool? value) {},
        value: false,
        // trailing: Box,
      ),
    );
  }
}
