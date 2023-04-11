import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import '../../domain/organization.dart';

class OrgCard extends ConsumerWidget {
  final Organization organization;
  final Widget? footer;

  const OrgCard({
    super.key,
    required this.organization,
    this.footer,
  });

  String getAddress() {
    final locations = organization.locations;
    final location =
        locations == null || locations.isEmpty ? null : locations[0];
    final String address;
    if (location == null) {
      address = 'Unknown';
    } else {
      final fullAddress = [
        location.locality,
        location.region,
        location.country,
      ].whereType<String>().join(', ');
      address = fullAddress.isNotEmpty ? fullAddress : 'Unknown';
    }
    return address;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logo = organization.logo;
    final address = getAddress();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          context.pushNamed(
            AppRoute.organization.name,
            params: {
              'id': organization.id.toString(),
            },
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: logo == null
                              ? Image.asset('assets/images/logo.png').image
                              : NetworkImage(getImageUrl(logo)),
                          radius: 24,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 4),
                              child: Text(
                                organization.name,
                                style:
                                    context.theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: context.theme.colorScheme.secondary,
                                  weight: 100,
                                  size: 18,
                                ),
                                Text(
                                  address,
                                  style: context.theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        organization.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          color: context.theme.primaryColor,
                          weight: 100,
                          size: 18,
                        ),
                        Text(
                          organization.numberOfMembers != null
                              ? '${organization.numberOfMembers} member(s)'
                              : '? member(s)',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '\u2022',
                            style: TextStyle(color: context.theme.primaryColor),
                          ),
                        ),
                        Icon(
                          Icons.volunteer_activism_outlined,
                          color: context.theme.primaryColor,
                          weight: 100,
                          size: 18,
                        ),
                        Text(
                          '1K activities',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    footer ??
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FilledButton.tonal(
                                onPressed: () {
                                  context.pushNamed(
                                    AppRoute.organization.name,
                                    params: {
                                      'id': organization.id.toString(),
                                    },
                                  );
                                },
                                child: const Text('Profile'),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
