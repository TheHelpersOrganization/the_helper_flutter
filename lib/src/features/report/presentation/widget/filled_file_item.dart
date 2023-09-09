import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/features/file/service/file_service.dart';

import '../../../../common/domain/file_info.dart';

class FilledFileItem extends ConsumerWidget {
  final FileInfoModel data;

  const FilledFileItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Icon(
                      Icons.attach_file,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.redAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          data.mimetype.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.size.toString(),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          // isLoading
          //     ? const CircularProgressIndicator()
          //     : Visibility(
          //         visible: onRemove != null,
          //         child: IconButton(
          //           icon: const Icon(
          //             Icons.clear_outlined,
          //             color: Colors.black54,
          //           ),
          //           onPressed: () => onRemove?.call(),
          //         ),
          //       ),
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.black54,
            ),
            onPressed: () async {
              ref.read(fileServiceProvider).downloadFileAndNotify(
                    fileModel: FileModel(
                      id: data.id!,
                      name: data.name,
                      mimetype: data.mimetype,
                    ),
                  );
            },
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
