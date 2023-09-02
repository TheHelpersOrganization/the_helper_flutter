import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'account_ranking_item.dart';
import 'activity_ranking_item.dart';
import 'organization_ranking_item.dart';

class AdminRankingView extends ConsumerWidget {
  const AdminRankingView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ChoiceChip(
            label: const Text('This year'),
            selected: true,
            onSelected: (value) {
              // setState(() {
              //   filterValue = 0;
              // });
            },
          ),
          ChoiceChip(
            label: const Text('Last year'),
            selected: false,
            onSelected: (value) {
              
            },
          ),
          ChoiceChip(
            label: const Text('All time'),
            selected: false,
            onSelected: (value) {
              
            },
          )
        ],
      ),
        const SizedBox(height: 15),
        const Text('Ranking'),
        const SizedBox(height: 15),
        const Expanded(
            child: Column(
          children: [
            AccountRankingItem(),
            OrganizationRankingItem(),
            ActivityRankingItem()
          ],
        ))
      ],
    );
  }
}
