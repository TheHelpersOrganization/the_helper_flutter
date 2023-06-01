import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabType {
  overview,
  shift,
}

class TabElement {
  final TabType type;
  final String tabTitle;
  final String? noDataTitle;
  final String? noDataSubtitle;

  const TabElement({
    required this.type,
    required this.tabTitle,
    this.noDataTitle,
    this.noDataSubtitle,
  });
}

const List<TabElement> tabs = [
  TabElement(
    type: TabType.overview,
    tabTitle: 'Overview',
    noDataTitle: 'No organization found',
    noDataSubtitle: 'Look like you haven\'t joined any organization yet',
  ),
  TabElement(
    type: TabType.shift,
    tabTitle: 'Shifts',
    noDataTitle: 'No pending join request',
  ),
];

final currentTabProvider = StateProvider<TabType>((ref) => TabType.overview);
