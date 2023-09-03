import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/admin_home_controller.dart';

import 'account_ranking_item.dart';
import 'activity_ranking_item.dart';
import 'admin_data_holder.dart';
import 'organization_ranking_item.dart';

class AdminRankingView extends ConsumerStatefulWidget {
  const AdminRankingView({
    super.key,
  });

  @override
  ConsumerState<AdminRankingView> createState() => _AdminRankingViewState();
}

class _AdminRankingViewState extends ConsumerState<AdminRankingView> {
  int filterValue = 0;

  List<Widget> _getRankingList(int filterValue, AdminRankingDataModel data) {
    switch (filterValue) {
      case 0:
        return data.account!.map((e) => AccountRankingItem(data: e)).toList();
      case 1:
        return data.organization!
            .map((e) => OrganizationRankingItem(data: e))
            .toList();
      case 2:
        return data.activity!.map((e) => ActivityRankingItem(data: e)).toList();
      default:
        return [const SizedBox()];
    }
  }

  Widget _getRankingTitle(int filterValue) {
    switch (filterValue) {
      case 0:
        return Text(
          'Most active users',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.orange),
        );
      case 1:
        return Text(
          'Most active organizations',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.redAccent),
        );

      case 2:
        return Text(
          'Treddning activities',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.blueAccent),
        );
      default:
        return Text(
          'N/A',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.blueAccent),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    filterValue = 2;
  }

  @override
  Widget build(BuildContext context) {
    final rankingData = ref.watch(adminRankingDataProvider(filterValue));
    final rankingTitle = _getRankingTitle(filterValue);
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ChoiceChip(
              label: const Text('Activity'),
              selected: filterValue == 2,
              onSelected: (value) {
                setState(() {
                  filterValue = 2;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Account'),
              selected: filterValue == 0,
              onSelected: (value) {
                setState(() {
                  filterValue = 0;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Organization'),
              selected: filterValue == 1,
              onSelected: (value) {
                setState(() {
                  filterValue = 1;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [rankingTitle],
        ),
        const SizedBox(height: 15),
        rankingData.when(
          error: (_, __) => const ErrorScreen(),
          loading: () => Expanded(
                  child: Center(
                    child: AdminDataHolder(
                      itemCount: 1,
                      itemWidth: context.mediaQuery.size.width * 0.8,
                      itemHeight: 350,
                    ),
                  ),
                ),
          data: (data) => Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _getRankingList(filterValue, data),
          )),
        ),
        const SizedBox(height: 5),
        const Divider(),
      ],
    );
  }
}
