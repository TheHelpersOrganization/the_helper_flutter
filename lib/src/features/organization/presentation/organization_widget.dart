import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/organization_placeholder.svg',
            width: context.mediaQuery.size.width * 0.3,
            fit: BoxFit.fill,
            alignment: Alignment.topLeft,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Helpers',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ly Thuong Kiet, Ward 14, District 10, Ho Chi Minh',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.tertiary,
                    ),
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  const Divider(),
                  const Text('100 members'),
                ].padding(const EdgeInsets.symmetric()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
