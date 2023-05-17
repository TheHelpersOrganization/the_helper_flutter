import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ActivityContactCard extends StatelessWidget {
  const ActivityContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = context.theme.textTheme.bodyMedium?.copyWith(
      color: context.theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.phone,
              color: context.theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(
          width: 8,
        ),
        OverflowBar(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manager', style: context.theme.textTheme.bodyLarge),
                Text('1232132132', style: subtitleStyle),
                Text('ABC ASDF SDFSDFDS', style: subtitleStyle),
              ],
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat),
              label: const Text('Chat'),
            )
          ],
        ),
      ],
    );
  }
}
