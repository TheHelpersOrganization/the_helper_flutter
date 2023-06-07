import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact_card.dart';

class ActivityContact extends StatelessWidget {
  final Activity activity;

  const ActivityContact({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        if (activity.contacts != null && activity.contacts!.isNotEmpty)
          Column(
            children: activity.contacts!
                .map((c) => ActivityContactCard(contact: c))
                .toList(),
          )
        else
          Text(
            'No contact found',
            style: TextStyle(color: context.theme.colorScheme.secondary),
          ),
      ],
    );
  }
}
