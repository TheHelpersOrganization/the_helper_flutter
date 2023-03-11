import 'package:flutter/material.dart';

//State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/controllers/home_screen_controller.dart';

//Nav Component
import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/navigation_item_list.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/bottom_navigator_item.dart';

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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: featuresLst
              .map<BottomNavigationBarItem>((item) => (NavBarTabItem(
                    icon: Icon(item.icon),
                    label: item.label,
                    initialLocation: item.path,
                  )))
              .toList(),
          currentIndex: currentIndex,
          onTap: (index) =>
              _onItemTapped(context, index, currentIndex, featuresLst),
        ));
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
