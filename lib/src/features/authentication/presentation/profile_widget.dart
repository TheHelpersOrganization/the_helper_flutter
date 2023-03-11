import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_controller.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Organization'),
  Tab(text: 'Detail'),
];

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          // final TabController tabController = DefaultTabController.of(context);
          // tabController.addListener(() {
          //   if (!tabController.indexIsChanging) {}
          // });
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  // expandedHeight: 600.0,
                  title: const Text('Profile'),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: const TabBar(tabs: tabs),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        color: index.isOdd ? Colors.white : Colors.black12,
                        child: Center(
                          child: Text('{$tabs.text!} Tab, row $index'),
                        ),
                      );
                    },
                    childCount: 5,
                  ),
                ),
              ],
            ),
            // appBar: AppBar(
            //   flexibleSpace: FlexibleSpaceBar(
            //     // title: const Text('Profile'),
            //     stretchModes: const <StretchMode>[
            //       StretchMode.zoomBackground,
            //       StretchMode.blurBackground,
            //       StretchMode.fadeTitle,
            //     ],
            //     centerTitle: true,
            //     background: Stack(
            //       fit: StackFit.expand,
            //       children: <Widget>[
            //         Image.network(
            //           'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
            //           fit: BoxFit.cover,
            //         ),
            //         const DecoratedBox(
            //           decoration: BoxDecoration(
            //             gradient: LinearGradient(
            //               begin: Alignment(0.0, 0.5),
            //               end: Alignment.center,
            //               colors: <Color>[
            //                 Color(0x60000000),
            //                 Color(0x00000000),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   bottom: const TabBar(
            //     tabs: tabs,
            //   ),
            // ),
            // body: TabBarView(
            //   children: tabs.map((Tab tab) {
            //     return Center(
            //       child: Text(
            //         '${tab.text!} Tab',
            //         style: Theme.of(context).textTheme.headlineSmall,
            //       ),
            //     );
            //   }).toList(),
            // ),
          );
        },
      ),
    );
  }
}
