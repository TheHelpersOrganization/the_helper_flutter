import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/router/router.dart';

class RoleOption extends ConsumerWidget {
  final Color optionColor;
  final String title;
  final String description;
  final Role role;
  final VoidCallback? onTap;
  final SvgPicture? image;

  const RoleOption({
    super.key,
    required this.title,
    required this.optionColor,
    required this.description,
    required this.role,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWell(
          onTap: onTap ??
              () async {
                // ref
                //     .read(homeScreenControllerProvider.notifier)
                //     .changeRole(role);
                await ref
                    .read(roleControllerProvider.notifier)
                    .setCurrentRole(role);

                if (context.mounted) {
                  context.goNamed(AppRoute.home.name);
                }
              },
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
                if (image == null)
                  Container(
                    //Add image here
                    margin: const EdgeInsets.all(5.0),
                    height: 95,
                    width: 95,
                    color: Colors.white,
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.all(4),
                    height: 95,
                    width: 95,
                    child: image!,
                  )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
