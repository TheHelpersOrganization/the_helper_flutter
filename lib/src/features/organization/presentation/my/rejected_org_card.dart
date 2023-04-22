import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

import 'org_card.dart';

class RejectedOrgCard extends ConsumerStatefulWidget {
  final Organization organization;

  const RejectedOrgCard({
    super.key,
    required this.organization,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RejectedOrgCardState();
}

class _RejectedOrgCardState extends ConsumerState<RejectedOrgCard> {
  @override
  Widget build(BuildContext context) {
    final organization = widget.organization;
    final myMember = widget.organization.myMembers?.reduce((value, element) =>
        value.updatedAt!.isAfter(element.updatedAt!) ? value : element);
    final reason = myMember?.rejectionReason;
    final dateOfRejection = myMember?.updatedAt == null
        ? 'Unknown'
        : DateFormat('dd/MM/yyyy').format(myMember!.updatedAt!);

    return OrgCard(
        organization: organization,
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reason == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'No reason was specified',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                : ExpansionTile(
                    title: Text(
                      'Click here show reason',
                      style: context.theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text('Date of rejection: $dateOfRejection'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          reason,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
            if (reason == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Date of rejection: $dateOfRejection'),
              ),
          ],
        ));
  }
}
