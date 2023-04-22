// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';

// class ChatBubble extends ConsumerWidget {
//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.isCurrentUser,
//   });
//   final String text;
//   final bool isCurrentUser;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: isCurrentUser ? Colors.blue : Colors.grey[300],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             text,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium!
//                 .copyWith(color: isCurrentUser ? Colors.white : Colors.black87),
//           )),
//     );
//   }
// }
