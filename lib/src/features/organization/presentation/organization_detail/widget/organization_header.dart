import 'package:avatar_stack/avatar_stack.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/report/domain/report_type.dart';

import '../../../../../common/extension/image.dart';
import '../../../../report/presentation/submit_report/screen/submit_report_screen.dart';
import '../../../data/organization_repository.dart';
import '../../../domain/organization.dart';
import '../../organization_search/organization_join_controller.dart';
import '../../organization_search/organization_leave_controller.dart';

class OrganizationHeaderWidget extends ConsumerStatefulWidget {
  final Organization organization;
  final double? bannerHeight;
  final double? logoHeight;

  const OrganizationHeaderWidget({
    super.key,
    required this.organization,
    this.bannerHeight,
    this.logoHeight,
  });

  @override
  ConsumerState<OrganizationHeaderWidget> createState() =>
      _OrganizationHeaderState();
}

class _OrganizationHeaderState extends ConsumerState<OrganizationHeaderWidget> {
  Future<dynamic> showJoinDialog() {
    final organization = widget.organization;
    final organizationJoinController =
        ref.watch(organizationJoinControllerProvider.notifier);

    return showDialog(
      useRootNavigator: false,
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

  Future<dynamic> showLeaveDialog() {
    final organization = widget.organization;
    final organizationLeaveController =
        ref.watch(organizationLeaveControllerProvider.notifier);

    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Row(
          children: [
            const Expanded(
              child: Text('Leave Organization'),
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
              text: 'Do you want to leave ',
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
                    _showLeaveLoadingDialog();
                    final res = await organizationLeaveController.leave(
                      organization.id!,
                    );
                    if (context.mounted) {
                      context.pop();
                      if (res != null) {
                        _showLeaveSuccessDialog();
                        ref.invalidate(
                            getOrganizationProvider(widget.organization.id!));
                      }
                    }
                  },
                  child: const Text('Leave'),
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

  void _showLeaveSuccessDialog() {
    showDialog(
      useRootNavigator: false,
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
                      text: 'Leave ',
                      children: [
                        TextSpan(
                          text: widget.organization.name,
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' success',
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

  void _showLeaveLoadingDialog() {
    showDialog(
      useRootNavigator: false,
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
                      text: 'Leaving ',
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

  Future<void> _openReport(
    // BuildContext context,
    Organization data,
  ) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SubmitReportScreen(
        id: data.id!,
        name: data.name.toString(),
        entityType: ReportType.organization,
        avatarId: data.logo,
        subText: data.email,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.organization;
    final bannerHeight = widget.bannerHeight ?? 200;
    final logoHeight = widget.logoHeight ?? 150;

    var topP = bannerHeight - logoHeight / 2;

    // List<int?> avatarList = data.myMembers;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: bannerHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageX.backend(data.banner!).image,
                      fit: BoxFit.cover),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: topP / 2,
                  width: topP / 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: FilledButton(
                    onPressed: data.hasJoined
                        ? null
                        : () {
                            showJoinDialog();
                          },
                    child: data.hasJoined
                        ? const Text('Joined')
                        : const Text('Join'),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: PopupMenuButton(
                      icon: const Icon(Icons.menu),
                      onSelected: (result) {
                        switch (result) {
                          case 0:
                            _openReport(data);
                            break;
                          case 1:
                            showLeaveDialog();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.report),
                              SizedBox(width: 8),
                              Text(
                                'Report this organization',
                              ),
                            ],
                          ),
                        ),
                        if (data.hasJoined)
                          const PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.group_off),
                                SizedBox(width: 8),
                                Text(
                                  'Leave this organization',
                                ),
                              ],
                            ),
                          ),
                      ],
                    )),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      data.name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  // description
                  ExpandableText(
                    data.description,
                    maxLines: 4,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium,
                    expandText: 'See More',
                    collapseText: 'See Less',
                    linkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  // members

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          (data.numberOfMembers ?? 0).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " Members",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: topP,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: logoHeight,
            width: logoHeight,
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: Theme.of(context).primaryColor,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: data.logo == null
                    ? Image.asset(
                        'assets/images/organization_placeholder.jpg',
                      ).image
                    : ImageX.backend(
                        data.logo!,
                      ).image,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
