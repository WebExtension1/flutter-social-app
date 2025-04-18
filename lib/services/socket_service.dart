import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket socket;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    String socketUrl = dotenv.env['SOCKET_URL'] ?? 'http://localhost:3006';

    socket = io.io(socketUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    socket.connect();
  }

  void sendMessage(String recipient, String message) {
    socket.emit("chat message", {"sender": _auth.currentUser!.email!, "recipient": recipient, "message": message});
  }

  void search(String query) {
    socket.emit("search", {"email": _auth.currentUser!.email!, 'query': query});
  }

  void dispose() {
    socket.dispose();
  }
}
