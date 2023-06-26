import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class NoteDialogWidget extends ConsumerWidget {
  const NoteDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textFieldController = TextEditingController();
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Please input reject\'s reason',
              style: context.theme.textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: textFieldController,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            )

          ),
            maxLines: 8,
            minLines: 5,
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // context.pop();
                  },
                  child: const Text('Reject'),
                ),
              ),
            ]
          )
        ],
      ),
    );
  }
}
