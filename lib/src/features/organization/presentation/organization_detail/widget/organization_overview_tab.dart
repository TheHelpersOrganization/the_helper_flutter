import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/presentation/organization_detail/controller/organization_overview_controller.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_name_map.dart';

import '../../../../../common/widget/detail_list_tile.dart';

class OrganizationOverviewTab extends ConsumerWidget {
  final int id;
  const OrganizationOverviewTab({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(organizationOverviewControllerProvider(id: id));
    return data.when(
      data: (data) => SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Overview'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildListDelegate([
                DetailListTile(
                  label: 'Total activites',
                  value: data.count.toString(),
                  labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                DetailListTile(
                  label: 'Ongoing activities', 
                  value: data.ongoingCount.toString()
                  ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: data.skillList == null
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FREQUENCY ACIVITIES\'S SKILLS',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children:[
                        ...data.skillList!
                        .map(
                          (skill) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Chip(
                                avatar: Icon(
                                    SkillIcons[skill.name]),
                                label: Text(skill.name)),
                          ),
                        )
                        .toList(),
                    ])
                  ],
                )
            ),
          ),
        ],
      ),
    ), 
      error: (Object error, StackTrace stackTrace) =>
          const Text('Some error orrcur!'),
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
