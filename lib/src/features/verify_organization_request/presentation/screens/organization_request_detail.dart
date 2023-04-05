import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/features/verify_organization_request/presentation/widgets/activity_type.dart';

//Screens
import 'package:the_helper/src/features/verify_organization_request/domain/org_request_model.dart';
import 'package:the_helper/src/features/verify_organization_request/data/org_request_repository.dart';
import 'package:the_helper/src/features/verify_organization_request/presentation/widgets/file_attachment.dart';

class OrganizationRequestDetailScreen extends ConsumerWidget {
  // final String? role;
  const OrganizationRequestDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgData = ref.watch(getOrganizationRequestModelProvider(0));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title:
            const Text('Request Detail', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 50,
              child: PrimaryButton(
                // isLoading: state.isLoading,
                loadingText: "Processing...",
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.error)),
                child: const Text('Reject'),
              ),
            ),
            SizedBox(
              width: 180,
              height: 50,
              child: PrimaryButton(
                // isLoading: state.isLoading,
                loadingText: "Processing...",
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary)),
                child: const Text('Approve'),
              ),
            )
          ],
        ),
      ),
      body: orgData.when(
        data: (orgData) =>  SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.blueGrey),
                  ),
                ),
                Text(
                  orgData.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(text: orgData.description),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Activities Type',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Wrap(
                  runSpacing: 20.0,
                  spacing: 20.0,
                  children: const [
                    ActivityTypeCard(
                      type: 'Healthcare',
                      icon: Icons.medical_services_outlined,
                    ),
                    ActivityTypeCard(
                      type: 'Enviroment',
                      icon: Icons.sunny,
                    ),
                    ActivityTypeCard(
                      type: 'Educating',
                      icon: Icons.menu_book,
                    ),
                    ActivityTypeCard(
                      type: 'Animal',
                      icon: Icons.pets,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address'),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: orgData.locations![0]
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Homepage'),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: orgData.website
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email Address'),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: orgData.email
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Telephone Number'),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: orgData.phoneNumber
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Attachments'),
                      for (var i in orgData.files!)
                        FileAttachment(data: i),
                    ],
                  ),
                ),
              ],
            ),
          ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      )
    );
  }
}
