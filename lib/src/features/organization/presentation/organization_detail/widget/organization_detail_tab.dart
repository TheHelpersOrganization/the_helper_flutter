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
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ...data.locations!
                    .map((e) => ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.location_city),
                          Flexible(child: Text(
                            getAddress(e),
                            textAlign: TextAlign.end,)),
                        ],
                      ),
                    )).toList(),
                  ],
                ): const SizedBox(),
                data.contacts != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Contact',
                        style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ...data.contacts!
                    .map((e) => ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(e.name),
                      trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(e.phoneNumber ?? 'None' ,
                        style: Theme.of(context).textTheme.labelLarge),
                        Text(e.email ?? 'None' ,
                        style: Theme.of(context).textTheme.labelLarge)
                      ]),
                    )).toList(),
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
