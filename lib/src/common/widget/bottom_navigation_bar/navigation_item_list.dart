import 'package:flutter/material.dart';

enum RoleFeatures {
  volunteer(
    role: 'volunteer',
    features: [
      FeaturePath(label: 'Home', path: '/', icon: Icons.home),
      FeaturePath(label: 'News', path: '/news', icon: Icons.newspaper),
      FeaturePath(
        label: 'Activities',
        path: '/activity/search',
        icon: Icons.search,
      ),
      FeaturePath(label: 'Chat', path: '/chat', icon: Icons.chat),
      FeaturePath(label: 'Menu', path: '/menu', icon: Icons.menu),
    ],
  ),
  mod(
    role: 'mod',
    features: [
      FeaturePath(label: 'Home', path: '/', icon: Icons.home),
      FeaturePath(label: 'Org', path: '/', icon: Icons.work),
      FeaturePath(
        label: 'Activities',
        path: '/activity/search',
        icon: Icons.search,
      ),
      FeaturePath(label: 'Chat', path: '/chat', icon: Icons.chat),
      FeaturePath(label: 'Menu', path: '/menu', icon: Icons.menu),
    ],
  ),
  admin(
    role: 'admin',
    features: [
      FeaturePath(label: 'Home', path: '/', icon: Icons.home),
      FeaturePath(label: 'Activities', path: '/activities', icon: Icons.search),
      FeaturePath(label: 'Chat', path: '/chat', icon: Icons.chat),
      FeaturePath(label: 'Menu', path: '/menu', icon: Icons.menu),
    ],
  );

  const RoleFeatures({required this.role, required this.features});

  final String role;
  final List<FeaturePath> features;
}

class FeaturePath {
  const FeaturePath({
    required this.label,
    required this.path,
    required this.icon,
  });

  final String label;
  final IconData icon;
  final String path;
}
