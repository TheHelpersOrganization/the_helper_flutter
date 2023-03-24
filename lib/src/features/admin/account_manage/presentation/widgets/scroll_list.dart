import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/features/admin/account_manage/domain/account.dart';
import 'package:simple_auth_flutter_riverpod/src/features/admin/account_manage/presentation/widgets/scroll_item.dart';

class CustomScrollList extends StatelessWidget {
  const CustomScrollList({
    super.key,
    required this.itemList,
  });

  final List<Account> itemList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: itemList
                  .map<Widget>((item) =>
                      CustomScrollItem(
                        name: item.name, 
                        email: item.email,
                        isBanned: item.isAccountDisabled,
                        isVerified: item.isAccountVerified,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
