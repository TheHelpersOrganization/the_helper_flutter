import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/screens/request_history_detail.dart';


class HistoryListItem extends ConsumerWidget {
  final AccountRequestModel data;

  const HistoryListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date = DateFormat('dd/MM/yyyy').format(data.createdAt);
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: InkWell(
            onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return RequestHistoryDetail(requestData: data);
                },
              ),
            );
          },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date),
                  const SizedBox(
                    height: 5,
                  ),
                  
                  Text(
                    data.note ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
