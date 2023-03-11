import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/navigation_item_list.dart';

class RoleMenu {
  final List<FeaturePath> ofProfile;
  final List<FeaturePath> ofMenu;
  final List<FeaturePath> ofAccount;

  RoleMenu({
    required this.ofProfile,
    required this.ofMenu,
    required this.ofAccount,
  });
}
