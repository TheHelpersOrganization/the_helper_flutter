import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';

class FileAttachment extends ConsumerWidget {
  const FileAttachment({
    super.key,
    required this.data,
  });
  final FileModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.amber,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name),
                    const Row(
                      children: [
                        Text('2.5 MB'),
                        Text('ZIP'),
                      ],
                    )
                  ],
                ),
              )
            ),
            IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
