

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

import 'activity_filter_organization.dart';
import 'activity_filter_skill.dart';

final formKey = GlobalKey<FormBuilderState>();

class ActivityFilterDrawer extends ConsumerWidget {
  const ActivityFilterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Activity Filter',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const ActivityFilterSkill(),
                    const SizedBox(height: 24),
                    const ActivityFilterOrganization(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
