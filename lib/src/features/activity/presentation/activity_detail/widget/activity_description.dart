import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

class ActivityDescription extends StatelessWidget {
  final Activity activity;

  const ActivityDescription({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ExpandableText(
          activity.description ?? 'No description',
          expandText: 'Show more',
          collapseText: 'Show less',
          maxLines: 3,
          collapseOnTextTap: true,
          linkColor: context.theme.primaryColor,
        ),
      ],
    );
  }
}
