import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

import 'package:flutter/services.dart';

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
                itemExtent: 72.0,
                delegate: SliverChildListDelegate(
                  [
                    for (final e in data)
                      ListTile(
                        onTap: () async {
                          String text = "Name: ${e.name}";
                          if (e.email != null) text += "\nEmail: ${e.email!}";
                          if (e.phoneNumber != null)
                            text += "\nPhone Number: ${e.phoneNumber!}";

                          await Clipboard.setData(
                            ClipboardData(text: text),
                          ).then(
                            (_) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Contact added to clipboard!"),
                              ),
                            ),
                          );
                        },
                        isThreeLine: true,
                        leading: const Icon(Icons.person),
                        title: Text(e.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.email ?? 'None',
                              // style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              e.phoneNumber ?? 'None',
                              // style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
