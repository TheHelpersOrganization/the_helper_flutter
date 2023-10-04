import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/router/router.dart';

import '../../../../../utils/domain_provider.dart';
import '../../../domain/report_query_parameter_classes.dart';

class CustomListItem extends ConsumerWidget {
  final ReportModel data;

  const CustomListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile =
        ref.watch(accountProfileServiceProvider(id: data.reporterId));
    final date = DateFormat("MM/dd/y").format(data.createdAt);
    final avatarId = data.reportedAccount?.avatarId ??
        data.reportedActivity?.thumbnail ??
        data.reportedOrganization?.logo;

    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: profile.when(
          loading: () => const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator()),
          ),
          error: (_, __) => const CustomErrorWidget(),
          data: (profile) => InkWell(
            onTap: () =>
              context.pushNamed(AppRoute.reportDetail.name, pathParameters: {
            'reportId': data.id.toString(),
          }),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: avatarId == null
                      ? Image.asset('assets/images/logo.png').image
                      : NetworkImage(getImageUrl(avatarId)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.title,
                                style: context.theme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(date),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          const Text('Type: '),
                          reportStatus(data.type)
                        ],),
                        Row(children: [
                          const Text('Report by:'),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: profile.avatarId == null
                                ? Image.asset('assets/images/logo.png').image
                                : NetworkImage(getImageUrl(profile.avatarId!)),
                            ),
                          ),
                          Text(profile.username 
                            ?? profile.email
                            ?? 'Unknow'),
                        ],),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget reportStatus(String status) {
    switch (status) {
      case ReportType.account:
        return const Text('Account',style: TextStyle(fontWeight: FontWeight.bold));
      case ReportType.organization:
        return const Text('Organization',style: TextStyle(fontWeight: FontWeight.bold));
      case ReportType.activity:
        return const Text('Activity',style: TextStyle(fontWeight: FontWeight.bold));
      case ReportType.news:
        return const Text('News',style: TextStyle(fontWeight: FontWeight.bold));
    }
    return const Text('Unknown',style: TextStyle(fontWeight: FontWeight.bold));
  }
}
