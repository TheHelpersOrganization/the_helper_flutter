import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_name_map.dart';
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
    final Widget skillsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'SKILLS',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        skills.isEmpty
            ? const Center(
                child: Text(
                  "You don't have any skill to show yet!",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : Column(
                children: [
                  ...skills
                      .map(
                        (skill) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                    avatar: Icon(SkillIcons[skill.name]),
                                    label: Text(skill.name)),
                                (skill.hours! >= 1)
                                    ? Text('${skill.hours.toString()} hours')
                                    : Text('${skill.hours.toString()} hour')
                              ]),
                        ),
                      )
                      .toList(),
                ],
              ),
        const Divider(),
      ],
    );
    final interestedList = profile.interestedSkills;
    final Widget interestedWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'INTERESTED',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: interestedList.isEmpty
              ? const Center(
                  child: Text(
                    "Edit your profile to add activity type you interested in",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...interestedList
                        .map(
                          (interested) => Chip(
                            avatar: Icon(SkillIcons[interested.name]),
                            label: Text(interested.name),
                          ),
                        )
                        .toList(),
                    const Divider(),
                  ],
                ),
        ),
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
              child: Column(
                children: [
                  skillsWidget,
                  interestedWidget,
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "BRIEF INFORMATION",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(4),
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
                    label: 'Gender',
                    value: profile.gender?.toUpperCase() ?? 'Unknown'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
