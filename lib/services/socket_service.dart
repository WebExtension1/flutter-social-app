import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    String socketUrl = dotenv.env['SOCKET_URL'] ?? 'http://localhost:3006';

    socket = IO.io(socketUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    socket.connect();

    socket.onConnect((_) {
      print("Connected to server");
    });

    socket.onDisconnect((_) {
      print("Disconnected from server");
    });
  }

  void sendMessage(String sender, String recipient, String message) {
    socket.emit("chat message", {"sender": sender, "recipient": recipient, "message": message});
  }

  void dispose() {
    socket.dispose();
  }
}
