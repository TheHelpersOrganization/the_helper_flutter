import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import '../../../domain/admin_organization.dart';
import '../screens/organization_request_detail_screen.dart';

class CustomListItem extends ConsumerWidget {
  final AdminOrganization data;

  const CustomListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fileNum = data.files.length;
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrganizationRequestDetailScreen(
                    data: data
                  );
                },
              ),
            );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: data.logo == null
                      ? Image.asset('assets/images/logo.png').image
                      : NetworkImage(getImageUrl(data.logo!)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: context.theme.textTheme.labelLarge
                                ?.copyWith(
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            data.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // RichText(
                          //   text: TextSpan(
                          //     text: data.note,
                          //   ),
                          //   softWrap: false,
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          fileNum != 0
                              ? Text("Attached file(s): $fileNum")
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
