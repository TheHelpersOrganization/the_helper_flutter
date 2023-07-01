import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/report/domain/report_message.dart';
import 'package:the_helper/src/features/report/presentation/widget/attached_files_list.dart';

import 'avatar_watcher.dart';

class ReportMessageWidget extends ConsumerWidget {
  final ReportMessageModel data;

  const ReportMessageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor))
      ),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AvatarWatcherWidget(
                avatarId: data.sender.avatarId,
                radius: context.mediaQuery.size.width * 0.03,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    data.sender.username
                  ),
                  Text(
                    DateFormat("dd-mm-y HH:mm").format(data.createdAt)
                  ),
                ],
              ),
            ),
            
          ],
        ),
        trailing: const SizedBox(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              data.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          data.files != null && data.files!.isNotEmpty
          ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uploaded files',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AttachedFilesList(files: data.files!),
                ),
              ],
            ),
          ): const SizedBox(),
        ],
      ),
    );
  }
}
