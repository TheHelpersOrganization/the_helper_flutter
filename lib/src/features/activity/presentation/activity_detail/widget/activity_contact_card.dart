import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/custom_list_tile.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ActivityContactCard extends StatelessWidget {
  final Contact contact;

  const ActivityContactCard({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 16),
        child: Icon(Icons.phone,
            color: context.theme.colorScheme.onSurfaceVariant),
      ),
      titleText: contact.name,
      subtitleText: contact.phoneNumber,
      subtitleText2: contact.email,
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.chat),
      ),
    );
  }
}
