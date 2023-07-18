import 'package:flutter/material.dart';

//State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/home_screen_controller.dart';

//Nav Component
import 'package:the_helper/src/common/widget/bottom_navigation_bar/navigation_item_list.dart';

class CustomBottomNavigator extends ConsumerWidget {
  const CustomBottomNavigator({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(homeScreenControllerProvider);

    //List of navigation bar's item based on user role
    final featuresLst = (userRole.role == 1)
        ? RoleFeatures.mod.features
        : (userRole.role == 2)
            ? RoleFeatures.admin.features
            : RoleFeatures.volunteer.features;

    int currentIndex = _locationToTabIndex(context.currentRoute, featuresLst);

    return Scaffold(
        body: child,
        );
  }

  int _locationToTabIndex(String location, List<FeaturePath> tabs) {
    final index = tabs.indexWhere((t) => location == t.path);
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  // Only navigate if the tab index has changed
  void _onItemTapped(BuildContext context, int tabIndex, int currentIndex,
      List<FeaturePath> tabs) {
    if (tabIndex != currentIndex) {
      context.go(tabs[tabIndex].path);
    }
  }
}
