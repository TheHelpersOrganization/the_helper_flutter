import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/domain/file_info.dart';

import 'filled_file_item.dart';

class AttachedFilesList extends ConsumerWidget {
  final List<FileInfoModel> files;

  const AttachedFilesList({
    super.key,
    required this.files,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return files.isNotEmpty
    ? Column(
      children: files
      .map((e) => FilledFileItem(data: e))
      .toList(),
    )
    : Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'There\'s no attached file',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
    );
  }
}
