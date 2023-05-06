import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';

import '../../../router/router.dart';

class AppDrawerDropDown extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<DrawerItemModel> subPaths;

  const AppDrawerDropDown({
    super.key,
    required this.title,
    required this.icon,
    required this.subPaths,
  });

  @override
  State<AppDrawerDropDown> createState() => _AppDrawerDropDownState();
}

class _AppDrawerDropDownState extends State<AppDrawerDropDown> {
  bool _customTileExpanded = false;

  bool hasSelected() {
    return widget.subPaths
        .any((child) => child.route?.path == context.currentRoute);
  }

  @override
  void initState() {
    // _customTileExpanded = hasSelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isSelected = widget.subPaths
    //     .any((child) => child.route?.path == context.currentRoute);
    // // print(isSelected);
    // _customTileExpanded = isSelected;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.black12,
          tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          title: Text(widget.title),
          leading: Icon(widget.icon),
          trailing: _customTileExpanded
              ? const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.arrow_left,
                  color: Colors.black,
                ),
          children: widget.subPaths
              .map<Widget>((item) => AppDrawerItem(
                    title: item.title,
                    icon: item.icon,
                    onTap: () {
                      context.goNamed(item.route != null
                          ? item.route!.name
                          : AppRoute.developing.name);
                    },
                  ))
              .toList(),
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
      ),
    );
    // return Ink(
    //   decoration: BoxDecoration(
    //     borderRadius: const BorderRadius.only(
    //         topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
    //     color: isSelected ? Theme.of(context).colorScheme.primary : null,
    //   ),
    //   child: Row(
    //     children: [
    //       if (isOpened)
    //       ...[
    //         ListTile(
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    //           title: Text(title,
    //               style:
    //                   isSelected ? const TextStyle(color: Colors.white) : null),
    //           leading: Icon(icon, color: (isSelected ? Colors.white : null)),
    //           trailing: isOpened
    //             ? Icon(Icons.arrow_left, color: Colors.black,)
    //             : Icon(Icons.arrow_drop_down, color: Colors.black,),
    //           onTap: () {
    //             isOpened = !isOpened;
    //           },
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(left: 5),
    //           child: Row(
    //             children: subPaths
    //               .map<Widget>((item) =>
    //                 AppDrawerItem(
    //                   route: item.route,
    //                   title: item.title,
    //                   icon: item.icon,
    //                   onTap: () {
    //                     context.goNamed(
    //                         item.route != null ? item.route!.name : AppRoute.developing.name);
    //                   },
    //                 )
    //             ).toList(),
    //           ),
    //         ),
    //       ]
    //       else ...[
    //         ListTile(
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    //           title: Text(title,
    //               style:
    //                   isSelected ? const TextStyle(color: Colors.white) : null),
    //           leading: Icon(icon, color: (isSelected ? Colors.white : null)),
    //           trailing: isOpened
    //             ? Icon(Icons.arrow_left, color: Colors.black,)
    //             : Icon(Icons.arrow_drop_down, color: Colors.black,),
    //           onTap: () {
    //             isOpened = !isOpened;
    //           },
    //         ),
    //       ]
    //     ],
    //   ),
    //   // ListTile(
    //   //   contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    //   //   title: Text(title,
    //   //       style: isSelected ? const TextStyle(color: Colors.white) : null),
    //   //   leading: Icon(icon, color: (isSelected ? Colors.white : null)),
    //   //   onTap: onTap,
    //   // ),
    // );
  }
}
