import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact_card.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ShiftContact extends StatelessWidget {
  final List<Contact>? contacts;

  const ShiftContact({
    super.key,
    required this.contacts,
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
        if (contacts != null && contacts!.isNotEmpty)
          Column(
            children:
                contacts!.map((c) => ActivityContactCard(contact: c)).toList(),
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
