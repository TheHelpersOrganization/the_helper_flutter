import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ShiftDescription extends StatelessWidget {
  final String? description;

  const ShiftDescription({
    super.key,
    this.description,
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
          description ?? 'No description',
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
