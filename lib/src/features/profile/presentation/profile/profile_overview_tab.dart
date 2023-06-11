import 'package:flutter/material.dart';
// import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';

class ProfileOverviewTab extends StatelessWidget {
  final List<Skill>? skills;
  final List<Skill>? interestedList;
  const ProfileOverviewTab({
    required this.skills,
    required this.interestedList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget skillsWidget = (skills == null)
        ? const Center(
            child: Text(
              "You don't have any skill to show yet!",
            ),
          )
        : Column(
            children: [
              Text(
                'SKILLS',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...skills!
                  .map(
                    (skill) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                                avatar: const Icon(Icons.wb_sunny_outlined),
                                label: Text(skill.name)),
                            (skill.hours! >= 1)
                                ? Text('${skill.hours.toString()} hours')
                                : Text('${skill.hours.toString()} hour')
                          ]),
                    ),
                  )
                  .toList(),
            ],
          );
    final Widget interestedWidget = (interestedList == null)
        ? const Center(
            child: Text(
              "Edit your profile to add activity type you interested in",
            ),
          )
        : Column(
            children: [
              Text(
                'INTERESTED',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...interestedList!
                      .map(
                        (interested) => Chip(
                          avatar: const Icon(Icons.wb_sunny_outlined),
                          label: Text(interested.name),
                        ),
                      )
                      .toList(),
                ],
              )
            ],
          );
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Overview'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Column(children: [
                skillsWidget,
                interestedWidget,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
