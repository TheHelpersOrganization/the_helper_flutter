import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';

import '../screens/account_request_detail_screen.dart';

class AccountRequestListItem extends ConsumerWidget {
  final AccountRequestModel data;

  const AccountRequestListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date =
        "${data.createdAt.day}/${data.createdAt.month}/${data.createdAt.year}";
    var cardTitle = "AccountID: #${data.accountId}";
    var fileNum = data.files.length ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AccountRequestDetailScreen(
                    requestData: data
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
                              cardTitle,
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
                        data.isVerified
                            ? Text(
                                'Verified account',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.apply(color: Colors.green),
                              )
                            : Text(
                                'Unverified account',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.apply(color: Colors.red),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: data.note,
                          ),
                          softWrap: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        fileNum != 0
                            ? Text("Attached file(s): $fileNum")
                            : const SizedBox(),
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
