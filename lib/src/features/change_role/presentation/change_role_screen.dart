import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  const SizedBox(height: 15,),
                  Text(
                    'Don\'t worry. You can change it later',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  ],
                )
              ),
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
                )
              ),
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
      children: [
        InkWell(
          child: Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.purple,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Volunteer',
                        style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Join thousands of activities, by trusted organizations',
                          style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
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
          onTap: () {},
        ),

        //Second Option
        const SizedBox(height: 20,),
        InkWell(
          child: Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.red,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organization',
                        style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Manage your organization activites, members and more',
                          style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
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
          onTap: () {},
        ),

        //Third Option
        const SizedBox(height: 20,),
        InkWell(
          child: Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Dashboard for Volunteer App Admin',
                          style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
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
          onTap: () {},
        ),
      ],
    );
  }
}
