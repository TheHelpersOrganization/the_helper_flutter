import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/common/widget/snack_bar.dart';
import 'package:the_helper/src/features/organization/presentation/organization_search/organization_list_widget.dart';

import 'organization_filter_controller.dart';
import 'organization_filter_drawer.dart';
import 'organization_join_controller.dart';
import 'organization_search_controller.dart';

class OrganizationSearchScreen extends ConsumerWidget {
  const OrganizationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);
    final organizationQuery = ref.watch(organizationQueryProvider);

    final sp = searchPattern != null ? ' for "$searchPattern"' : '';
    final wq = organizationQuery != null ? ' with applied filter' : '';

    ref.listen<AsyncValue<void>>(
      organizationJoinControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBarFromException(error),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Organization'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      endDrawer: const OrganizationFilterDrawer(),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(12),
          child: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DebounceSearchBar(
                            debounceDuration: const Duration(seconds: 1),
                            onDebounce: (value) {
                              if (value.trim().isEmpty) {
                                ref.read(searchPatternProvider.notifier).state = null;
                              } else {
                                ref.read(searchPatternProvider.notifier).state = value;
                              }
                              ref.read(hasUsedSearchProvider.notifier).state = true;
                            },
                            onClear: () {
                              ref.read(searchPatternProvider.notifier).state = null;
                              ref.read(hasUsedSearchProvider.notifier).state = true;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(
                            Icons.filter_list_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (searchPattern != null || organizationQuery != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Search result for "$sp$wq"',
                                style: context.theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (organizationQuery != null)
                                TextButton(
                                  onPressed: () {
                                    ref.read(searchPatternProvider.notifier).state = '';
                    
                                    ref.invalidate(organizationQueryProvider);
                                    ref.read(isMarkedToResetProvider.notifier).state =
                                        false;
                                  },
                                  child: const Text(
                                    'Clear filter',
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                    else
                      const SizedBox(
                        height: 24,
                      ),
                  ],
                ),
              ),
            ],
            body: const OrganizationListWidget()
          ),
        ),
      ),
    );
  }

//   Widget _buildFilter(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Divider(),
//           _buildActivityTypeFilter(),
//           const Divider(),
//           _builderMemberFilter(context),
//           const Divider(),
//         ],
//       ),
//     );
//   }

//   Widget _builderMemberFilter(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Row(
//           children: [
//             Icon(
//               Icons.person_outline_rounded,
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Text(
//               'Members',
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Row(
//           children: [
//             const Text(
//               'From',
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             Expanded(
//               child: TextField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.all(8),
//                   isDense: true,
//                 ),
//                 style: const TextStyle(fontSize: 16),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             const Text(
//               'To',
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             Expanded(
//               child: TextField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.all(8),
//                   isDense: true,
//                 ),
//                 style: const TextStyle(fontSize: 16),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ]),
//     );
//   }

//   Widget _buildActivityTypeFilter() {
//     return Column(
//       children: [
//         const Row(
//           children: [
//             Icon(
//               Icons.work_outline_rounded,
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Text(
//               'Activity Type',
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         FormBuilderFilterChip(
//           name: 'activityType',
//           spacing: 12,
//           runSpacing: 12,
//           decoration: const InputDecoration(border: InputBorder.none),
//           options: const [
//             FormBuilderChipOption(
//               value: 'a',
//               child: Text('a'),
//             ),
//             FormBuilderChipOption(
//               value: 'b',
//               child: Text('b'),
//             ),
//             FormBuilderChipOption(
//               value: 'c',
//               child: Text('b'),
//             ),
//             FormBuilderChipOption(
//               value: 'd',
//               child: Text('b'),
//             ),
//             FormBuilderChipOption(
//               value: 'e',
//               child: Text('b'),
//             ),
//             FormBuilderChipOption(
//               value: 'f',
//               child: Text('b'),
//             ),
//           ],
//         )
//       ],
//     );
//   }
}
