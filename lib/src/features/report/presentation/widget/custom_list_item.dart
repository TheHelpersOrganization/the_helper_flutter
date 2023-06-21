import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/report/domain/report.dart';
import 'package:the_helper/src/features/report/presentation/screen/report_detail_screen.dart';

import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/popup_menu_button.dart';


class CustomListItem extends ConsumerWidget {
  final ReportModel data;

  const CustomListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date =
        "${data.createdAt.day}/${data.createdAt.month}/${data.createdAt.year}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ReportDetailScreen(
                    reportData: data
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text('A'),
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
                            Text(
                              data.accusedName,
                              style: context.theme.textTheme.labelLarge?.copyWith(
                                fontSize: 18,
                              ),
                            ),
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
                          child: Text(
                            'Reported for being: ${data.reportType}',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
