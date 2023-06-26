import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/organization/domain/organization_request_model.dart';

class CustomListItem extends ConsumerWidget {
  final OrganizationRequestModel data;

  const CustomListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var date =
    //     "${data.time.hour}:${data.time.minute} ~ ${data.time.day}/${data.time.month}/${data.time.year}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => context.goNamed('organization-request-detail'),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text('A'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name),
                      Text(data.email),
                      RichText(
                        text: const TextSpan(
                            text:
                                'Some location that the string is too long to fit in a card on flutter widget without break a new line'),
                        softWrap: false,
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.chevron_right)),
              ],
            ),
          ),
        )
      ),
    );
  }
}
