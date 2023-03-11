import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/navigation_item_list.dart';
import 'package:simple_auth_flutter_riverpod/src/features/menu/domain/role_menu.dart';
import 'package:flutter/material.dart';

RoleMenu volunteerList =
  RoleMenu(
    ofProfile: [
      const FeaturePath(label: 'Profile', path: '', icon: Icons.abc)
    ], 
    ofMenu: [
      const FeaturePath(label: 'Report', path: '', icon: Icons.report),
      const FeaturePath(label: 'Create Org', path: '', icon: Icons.business_center),
      const FeaturePath(label: 'Setting', path: '', icon: Icons.settings),
      const FeaturePath(label: 'Term of use', path: '', icon: Icons.content_paste),
    ], 
    ofAccount: [
      const FeaturePath(label: 'Switch View', path: '', icon: Icons.change_circle),
      const FeaturePath(label: 'Logout', path: '', icon: Icons.logout),
    ]
  );

RoleMenu modList =
  RoleMenu(
    ofProfile: [
      const FeaturePath(label: 'Profile', path: '', icon: Icons.abc),
      const FeaturePath(label: 'Org Profile', path: '', icon: Icons.abc),
    ], 
    ofMenu: [
      const FeaturePath(label: 'Report', path: '', icon: Icons.report),
      const FeaturePath(label: 'Setting', path: '', icon: Icons.settings),
      const FeaturePath(label: 'Term of use', path: '', icon: Icons.content_paste),
    ], 
    ofAccount: [
      const FeaturePath(label: 'Switch View', path: '', icon: Icons.change_circle),
      const FeaturePath(label: 'Logout', path: '', icon: Icons.logout),
    ]
  );

RoleMenu adminList =
  RoleMenu(
    ofProfile: [
      const FeaturePath(label: 'Profile', path: '', icon: Icons.abc),
    ], 
    ofMenu: [
      const FeaturePath(label: 'Report', path: '', icon: Icons.report),
      const FeaturePath(label: 'Setting', path: '', icon: Icons.settings),
      const FeaturePath(label: 'Term of use', path: '', icon: Icons.content_paste),
    ], 
    ofAccount: [
      const FeaturePath(label: 'Switch View', path: '', icon: Icons.change_circle),
      const FeaturePath(label: 'Logout', path: '', icon: Icons.logout),
    ]
  );
