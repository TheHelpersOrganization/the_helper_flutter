import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

final socketProvider = Provider.autoDispose<io.Socket>((ref) {
  final url = ref.watch(baseWsUrlProvider);
  final authService = ref.watch(authServiceProvider.notifier);

  final socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuthFn((callback) async {
            final token = await authService.getToken();
            callback({
              'token': token?.accessToken,
            });
          })
          .build());

  socket.connect();

  socket.onConnect((_) {
    print('connect');
  });
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('error', (data) => print(data));

  ref.onDispose(() {
    socket.dispose();
  });

  return socket;
});
