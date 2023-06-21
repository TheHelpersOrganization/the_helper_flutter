import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/summary_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/screens/error_screen.dart';
import '../../../authentication/application/auth_service.dart';
import '../../../profile/data/profile_repository.dart';
import '../controllers/admin_home_controller.dart';
import '../widgets/adminDataHolder.dart';
import '../widgets/home_welcome_section.dart';

class ScreenBuilderCanvas extends ConsumerWidget {
  const ScreenBuilderCanvas({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            // Hello section
            HomeWelcomeSection(
              // volunteerName: data.lastName ?? data.username ?? email,
              volunteerName: 'James',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      child: TabBarView(
                        children: [
                          AdminDataCard(),
                          Container(
                            child: Text("Articles Body"),
                          ),
                          Container(
                            child: Text("User Body"),
                          ),
                        ]
                      ),
                    ),
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(text: "Home"),
                          Tab(text: "Articles"),
                          Tab(text: "User"),
                        ]
                      ),
                    ),
                  ]
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class AdminDataCard extends StatelessWidget {
  const AdminDataCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.account_circle),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Colors.blue,
                          child: Text('Account')),
                        Container(
                          color: Colors.amber,
                          child: Text('data')),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      
                      color: Colors.grey,
                      child: Text('Request')),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      
                      color: Colors.green,
                      child: Text('Report')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
