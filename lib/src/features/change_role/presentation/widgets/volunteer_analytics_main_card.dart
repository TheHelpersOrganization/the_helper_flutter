import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class VolunteerAnalyticsMainCard extends StatelessWidget {
  const VolunteerAnalyticsMainCard({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimaryColor = context.theme.colorScheme.onPrimary;

    return Card(
      color: context.theme.primaryColor,
      margin: const EdgeInsets.only(right: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bubble_chart,
                  color: onPrimaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Analytics',
                  style: TextStyle(color: onPrimaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            RichText(
              maxLines: 2,
              text: TextSpan(
                text: '30K',
                style: context.theme.textTheme.headlineLarge?.copyWith(
                  color: onPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '  Impression',
                    style: context.theme.textTheme.bodyMedium
                        ?.copyWith(color: onPrimaryColor),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 0,
                indent: 0,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: onPrimaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Top skills',
                  style: TextStyle(color: onPrimaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Wrap(
              runSpacing: 4,
              spacing: 4,
              children: const [
                Chip(
                  avatar: Icon(Icons.medical_services_outlined),
                  label: Text('Healthcare'),
                  elevation: 1,
                ),
                Chip(
                  avatar: Icon(Icons.menu_book_outlined),
                  label: Text('Educating'),
                  elevation: 1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
