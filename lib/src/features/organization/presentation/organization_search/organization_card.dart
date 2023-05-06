import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import '../../domain/organization.dart';
import 'organization_join_controller.dart';

class OrganizationCard extends ConsumerStatefulWidget {
  final Organization organization;

  const OrganizationCard({super.key, required this.organization});

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
  ConsumerState<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends ConsumerState<OrganizationCard> {
  Future<dynamic> showJoinDialog() {
    final organization = widget.organization;
    final organizationJoinController =
        ref.watch(organizationJoinControllerProvider.notifier);

    return showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Row(
          children: [
            const Expanded(
              child: Text('Join Organization'),
            ),
            IconButton(
              onPressed: () {
                dialogContext.pop();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        children: [
          RichText(
            text: TextSpan(
              text: 'Do you want to join ',
              children: [
                TextSpan(
                  text: organization.name,
                  style: TextStyle(
                    color: dialogContext.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    dialogContext.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () async {
                    dialogContext.pop();
                    _showJoinLoadingDialog();
                    final res = await organizationJoinController.join(
                      organization.id!,
                    );
                    if (context.mounted) {
                      context.pop();
                      if (res != null) {
                        _showJoinSuccessDialog();
                      }
                    }
                  },
                  child: const Text('Join'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showJoinSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 36,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Your request to join ',
                      children: [
                        TextSpan(
                          text: widget.organization.name,
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' has been received',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'After your request is approved, you will be a member of this organization',
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showJoinLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Joining ',
                      children: [
                        TextSpan(
                          text: widget.organization.name,
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('This may take a few minutes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final organization = widget.organization;
    final logo = organization.logo;
    final address = widget.getAddress();
    final joinedOrganizationIds = ref.watch(joinedOrganizationIdsProvider);
    final hasJoined = joinedOrganizationIds.any((id) => id == organization.id);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                            padding: const EdgeInsets.only(left: 4, bottom: 4),
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
                          child: const Text('Details'),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: hasJoined
                              ? null
                              : () {
                                  showJoinDialog();
                                },
                          child: hasJoined
                              ? const Text('Joined')
                              : const Text('Join'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
