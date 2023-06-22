import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
// import 'package:the_helper/src/features/profile/domain/profile.dart';

class ProfileOverviewTab extends StatelessWidget {
  final Profile profile;
  const ProfileOverviewTab({
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final skills = profile.skills;
    final Widget skillsWidget = skills.isEmpty
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
              ...skills
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
    final interestedList = profile.interestedSkills;
    final Widget interestedWidget = interestedList.isEmpty
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
                  ...interestedList
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
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildListDelegate([
                DetailListTile(
                    label: 'Phone Number',
                    value: profile.phoneNumber ?? 'Unknown'),
                DetailListTile(
                    label: 'First Name', value: profile.firstName ?? 'Unknown'),
                DetailListTile(
                    label: 'Last Name', value: profile.lastName ?? 'Unknown'),
                DetailListTile(
                    label: 'Date of Birth',
                    value:
                        DateFormat('dd-MM-yyyy').format(profile.dateOfBirth!)),
                DetailListTile(
                    label: 'Gender', value: profile.gender ?? 'Unknown'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
