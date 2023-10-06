import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class AccountRequestListItem extends ConsumerWidget {
  final AccountRequestModel data;

  const AccountRequestListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile =
        ref.watch(accountProfileServiceProvider(id: data.accountId!));
    var date = DateFormat('dd/MM/yyyy').format(data.createdAt);
    var fileNum = data.files.length;

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
            onTap: () => context.pushNamed(
              AppRoute.accountRequestDetail.name,
              pathParameters: {
                'requestId': data.id.toString(),
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: profile.avatarId == null
                          ? Image.asset('assets/images/logo.png').image
                          : NetworkImage(getImageUrl(profile.avatarId!)),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  profile.username!,
                                  style: context.theme.textTheme.labelLarge
                                      ?.copyWith(
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(date),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text('Account Id:'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(data.accountId.toString()),
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
                          data.note != null
                              ? Text(
                                  data.note ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox(),
                          // RichText(
                          //   text: TextSpan(
                          //     text: data.note,
                          //   ),
                          //   softWrap: false,
                          // ),
                          fileNum != 0
                              ? const SizedBox(
                                  height: 10,
                                )
                              : const SizedBox(),
                          fileNum != 0
                              ? Text("Attached file(s): $fileNum")
                              : const SizedBox(),
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
}
