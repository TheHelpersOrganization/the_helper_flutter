import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class HomeWelcomeSection extends StatelessWidget {
  final String volunteerName;

  const HomeWelcomeSection({
    super.key,
    required this.volunteerName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: context.theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                      color: context.theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            OverflowBar(
              children: [
                Text(
                  'Welcome ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  volunteerName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }
}
