import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ProfileContactsTab extends StatelessWidget {
  final AsyncValue<List<Contact>> contacts;
  const ProfileContactsTab({
    required this.contacts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Contact'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          contacts.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, st) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
            data: (data) => SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildListDelegate([
                  for (final e in data)
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(e.name),
                      trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(e.email ?? 'None' ,
                        style: Theme.of(context).textTheme.bodyLarge),
                        Text(e.phoneNumber ?? 'None' ,
                        style: Theme.of(context).textTheme.bodyLarge)
                      ]),
                    )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
