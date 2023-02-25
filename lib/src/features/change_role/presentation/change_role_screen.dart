import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangeRoleScreen extends ConsumerWidget {
  const ChangeRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Choose your role',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Don\'t worry. You can change it later',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )),
            ),
            const RoleChoice(),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not sure what to do?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See here',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleChoice extends StatelessWidget {
  const RoleChoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        RoleOption(
          optionColor: Colors.purple,
          title: 'Volunteer',
          description: 'Join thousands of activities, by trusted organizations',
          role: 0,
        ),

        //Second Option
        SizedBox(
          height: 20,
        ),
        RoleOption(
          optionColor: Colors.red,
          title: 'Organization',
          description: 'Manage your organization activites, members and more',
          role: 1,
        ),

        //Third Option
        SizedBox(
          height: 20,
        ),
        RoleOption(
          optionColor: Colors.blue,
          title: 'Admin',
          description: 'Dashboard for Volunteer App Admin',
          role: 2,
        ),
      ],
    );
  }
}

class RoleOption extends StatelessWidget {
  final Color optionColor;
  final String title;
  final String description;
  final int role;

  const RoleOption({
    super.key,
    required this.title,
    required this.optionColor,
    required this.description,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 100,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: optionColor,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              //Add image here
              margin: const EdgeInsets.all(5.0),
              height: 95,
              width: 95,
              color: Colors.white,
            )
          ],
        ),
      ),
      onTap: () => context.goNamed('homescreen', params: {'role': role.toString()}),
    );
  }
}
