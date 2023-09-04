import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/admin_analytic/domain/organization_analytic_model.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:intl/intl.dart';

class OrganizationRankingItem extends StatelessWidget {
  final OrganizationAnalyticModel data;
  const OrganizationRankingItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat.compact(locale: "en_US");
    final timeAdd = f.format(data.hoursContributed!);
    return Flexible(
      flex: 1,
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                AppRoute.organization.name,
                pathParameters: {
                  'orgId': data.id.toString(),
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: data.logo == null
                        ? Image.asset('assets/images/logo.png').image
                        : NetworkImage(getImageUrl(data.logo!)),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          overflow: TextOverflow.ellipsis,
                          'Email: ${data.email}')
                    ],
                  ),
                ),
                Text(
                  '+ $timeAdd h',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}
