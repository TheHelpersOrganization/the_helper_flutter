import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:go_router/go_router.dart';
import '../../../router/router.dart';

class AppDrawerDropDown extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isSelected =
        subPaths.any((child) => child.route?.path == context.currentRoute);
    bool isOpened = isSelected;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ExpansionTile(
        // tilePadding: const EdgeInsets.only(right: 8.0),
        title: Text(title),
        leading: Icon(icon),
        trailing: isOpened
            ? const Icon(
                Icons.arrow_left,
                color: Colors.black,
              )
            : const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
        children: subPaths
            .map<Widget>((item) => AppDrawerItem(
                  route: item.route,
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
          isOpened = expanded;
        },
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
