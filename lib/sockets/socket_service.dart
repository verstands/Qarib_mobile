import 'package:emol/constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initializeSocket() {
    socket = IO.io('${getSocket}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  void listenToPositionUpdates(Function callback) {
    socket.on('userPositionUpdate', (data) {
      callback(data);
    });
  }

  void disconnectSocket() {
    socket.disconnect();
  }
}
