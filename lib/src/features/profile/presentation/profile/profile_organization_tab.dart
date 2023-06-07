import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/router/router.dart';

class ProfileOrganizationTab extends StatelessWidget {
  final AsyncValue<List<Organization>> orgs;
  const ProfileOrganizationTab({
    required this.orgs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Organization'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          orgs.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, st) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
            data: (orgs) => SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildListDelegate([
                  for (final org in orgs)
                    ListTile(
                      // isThreeLine: true,
                      onTap: () {
                        context.pushNamed(
                          AppRoute.organization.name,
                          pathParameters: {
                            'orgId': org.id.toString(),
                          },
                        );
                      },
                      leading: const Icon(Icons.star_outline),
                      title: Text(org.name),
                    ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
