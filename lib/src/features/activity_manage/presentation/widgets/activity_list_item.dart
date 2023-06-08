import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity_manage/domain/activity.dart';
import 'package:the_helper/src/router/router.dart';

class ActivityListItem extends ConsumerWidget {
  final ActivityModel data;

  const ActivityListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date = "${data.startTime.year}/${data.startTime.month}/${data.startTime.day} - ${data.endTime.year}/${data.endTime.month}/${data.endTime.day}";
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            print('ddddd');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 50,
                height: 50,
                color: Colors.amber,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    Text(data.name),
                    Text(data.shortDescription),
                  ],
                ),
              ),
              Text('2 day ago'),
            ],
          ),
        ));
  }
}
