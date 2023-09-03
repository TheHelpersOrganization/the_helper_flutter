import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/admin_analytic/domain/activity_analytic_model.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class ActivityRankingItem extends StatelessWidget {
  final ActivityAnalyticModel data;

  const ActivityRankingItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat.compact(locale: "en_US");
    final joined = f.format(data.joinedParticipants!);
    return Flexible(
      flex: 1,
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                AppRoute.activity.name,
                pathParameters: {
                  'activityId': data.id.toString(),
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
                    backgroundImage: data.thumbnail == null
                        ? Image.asset('assets/images/logo.png').image
                        : NetworkImage(getImageUrl(data.thumbnail!)),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        data.name ?? 'Unknow',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Text('By:'),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: data.organizationLogo == null
                                  ? Image.asset('assets/images/logo.png').image
                                  : NetworkImage(
                                      getImageUrl(data.organizationLogo!)),
                            ),
                          ),
                          Text(data.organizationName ?? 'Unknow'),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '$joined participants',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}
