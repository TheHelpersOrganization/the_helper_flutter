import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/utils/location.dart';

import '../../../domain/organization.dart';

class OrganizationDetailTab extends StatelessWidget {
  final Organization data;

  const OrganizationDetailTab({
    required this.data,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Detail'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                
                DetailListTile(
                    label: 'Name',
                    value: data.name),
                DetailListTile(
                    label: 'Email', value: data.email),
                DetailListTile(
                    label: 'Phone Number', value: data.phoneNumber),
                DetailListTile(
                    label: 'Website',
                    value: data.website),
                data.locations != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ...data.locations!
                      .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(getAddress(e)),
                      )).toList(),
                    ],
                  ),
                ): const SizedBox(),
                data.contacts != null
                ? Column(
                  children: [
                    const Text('Contact'),
                    ...data.contacts!
                    .map((e) => Text(e.toString())).toList(),
                  ],
                ): const SizedBox(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
