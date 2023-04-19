import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/features/account_manage/presentation/widgets/popup_menu_button.dart';

class AccountListItem extends ConsumerWidget {
  final AccountModel data;

  const AccountListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text('A'),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.email),
                  ],
                ),
              ),
              data.isAccountVerified
                  ? Center(
                      child: Text(
                        'Verified',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.apply(color: Colors.green),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Not verified',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.apply(color: Colors.red),
                      ),
                    ),
              PopupButton(accountId: data.id)
            ],
          ),
        ));
  }
}
