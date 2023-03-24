import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer.dart';
import 'package:simple_auth_flutter_riverpod/src/features/admin/account_manage/presentation/widgets/scroll_list.dart';

//Screens
import 'package:simple_auth_flutter_riverpod/src/features/admin/account_manage/domain/account.dart';
const List<Tab> tabs = <Tab>[
  Tab(text: 'Active'),
  Tab(text: 'Banned'),
];

const List<Account> accList = <Account>[
  Account(id: 0, name:'AAA', email: 'df@gmail.com', isAccountDisabled: true, isAccountVerified: false),
  Account(id: 0, name:'asc', email: 'f@gmadil.com', isAccountDisabled: true, isAccountVerified: true),
];

class AccountManageScreen extends ConsumerWidget {
  // final String? role;
  const AccountManageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final userRole = ref.watch(homeScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text('Account Management', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back)
          ),
        ),
      // drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: MySliverPersistentHeaderDelegate(
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    tabs: tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: const TabBarView(
            children: [
              CustomScrollList(itemList: accList),
              CustomScrollList(itemList: accList),
            ],
          ),
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
