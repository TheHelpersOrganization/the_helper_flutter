import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';

class NewsOrganizationAndDate extends StatelessWidget {
  final MinimalOrganization organization;
  final DateTime publishedAt;
  final bool numericDates;

  const NewsOrganizationAndDate({
    super.key,
    required this.organization,
    required this.publishedAt,
    this.numericDates = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            context.pushNamed(
              AppRoute.organization.name,
              pathParameters: {
                AppRouteParameter.organizationId: organization.id.toString(),
              },
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: getBackendImageOrLogoProvider(
                  organization.logo,
                ),
                radius: 12,
              ),
              const SizedBox(width: 8),
              Text(
                organization.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        const Text('•'),
        const SizedBox(width: 4),
        Text(
          publishedAt.timeAgo(numericDates: numericDates),
          style: TextStyle(
            color: context.theme.colorScheme.secondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
