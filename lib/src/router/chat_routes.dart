import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/chat/presentation/chat/screen/chat_screen.dart';
import 'package:the_helper/src/features/chat/presentation/chat_list/screen/chat_list_screen.dart';
import 'package:the_helper/src/router/router.dart';

final chatRoutes = GoRoute(
  path: AppRoute.chats.path,
  name: AppRoute.chats.name,
  builder: (context, state) => const ChatListScreen(),
  routes: [
    GoRoute(
      path: AppRoute.chat.path,
      name: AppRoute.chat.name,
      builder: (context, state) => ChatScreen(
        chatId: int.parse(
          state.pathParameters['chatId']!,
        ),
      ),
    ),
  ],
);
