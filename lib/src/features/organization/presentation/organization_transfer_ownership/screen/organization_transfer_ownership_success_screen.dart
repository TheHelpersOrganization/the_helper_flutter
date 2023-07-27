import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/organization/presentation/organization_transfer_ownership/controller/organization_transfer_ownership_controller.dart';
import 'package:the_helper/src/router/router.dart';

class OrganizationTransferOwnershipSuccessScreen extends ConsumerWidget {
  const OrganizationTransferOwnershipSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationTransferOwnershipState =
        ref.watch(organizationTransferOwnershipControllerProvider);
    final selectedMember = ref.watch(selectedMemberProvider);

    // if (selectedMember == null) {
    //   return const DevelopingScreen();
    // }

    return Scaffold(
      body: organizationTransferOwnershipState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const CustomErrorWidget(),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/ok.svg',
              fit: BoxFit.fitHeight,
              height: 300,
            ),
            const SizedBox(height: 24),
            Text(
              'Organization Ownership Transferred Successfully',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.goNamed(AppRoute.home.name);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
