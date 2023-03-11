import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/router/router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/controllers/home_screen_controller.dart';

class RoleOption extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InkWell(
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
          onTap: () {
            ref.read(homeScreenControllerProvider.notifier).changeRole(role);
            context.goNamed(AppRoute.home.name);
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}