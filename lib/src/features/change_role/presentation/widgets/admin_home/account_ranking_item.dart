import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/admin_analytic/domain/account_analytic_model.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class AccountRankingItem extends StatelessWidget {
  final AccountAnalyticModel data;
  const AccountRankingItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String name = (data.firstName ?? '') + (data.lastName ?? '');
    var f = NumberFormat.compact(locale: "en_US");
    final timeAdd = f.format(data.hoursContributed!);
    return Flexible(
      flex: 1,
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                AppRoute.otherProfile.name,
                pathParameters: {
                  'userId': data.id.toString(),
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
                    backgroundImage: data.avatarId == null
                        ? Image.asset('assets/images/logo.png').image
                        : NetworkImage(getImageUrl(data.avatarId!)),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? (data.username ?? 'Unknow') : name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          overflow: TextOverflow.ellipsis,
                          'Email: ${data.email ?? 'None'}')
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
