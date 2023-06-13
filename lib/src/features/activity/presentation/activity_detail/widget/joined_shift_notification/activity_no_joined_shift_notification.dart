import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ActivityNoJoinedShiftNotification extends StatelessWidget {
  final VoidCallback? onSuggestionTap;

  const ActivityNoJoinedShiftNotification({
    super.key,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You have not registered to this activity.',
          style: TextStyle(
            color: context.theme.colorScheme.secondary,
          ),
        ),
        Row(
          children: [
            Text(
              'Tap',
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(1),
                ),
              ),
              onPressed: onSuggestionTap,
              child: const Text('Shifts'),
            ),
            Text(
              'to start registering.',
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
              ),
            )
          ],
        ),
      ],
    );
  }
}
