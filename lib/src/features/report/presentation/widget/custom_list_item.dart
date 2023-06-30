import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
import 'package:the_helper/src/features/report/presentation/screen/report_detail_screen.dart';

import '../../../../utils/domain_provider.dart';

class CustomListItem extends ConsumerWidget {
  final AdminReportModel data;

  const CustomListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat("mm/dd/y").format(data.createdAt);
    final avatarId = 
    data.reportedAccount?.avatarId 
    ?? data.reportedActivity?.thumbnail
    ?? data.reportedOrganization?.logo;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ReportDetailScreen(reportData: data);
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
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
                                style:
                                    context.theme.textTheme.labelLarge?.copyWith(
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Text(date),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     text: data.note,
                        //   ),
                        //   softWrap: false,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status:  ',
                                  style:
                                      context.theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: data.status,
                                )
                              ]
                            )
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
