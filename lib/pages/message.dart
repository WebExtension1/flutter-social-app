import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/services/socket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.account});
  final Account account;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final SocketService socketService = SocketService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    socketService.socket.on("chat message", (data) {
      print("New message from ${data['sender']}: ${data['recipient']}: ${data['message']}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              socketService.sendMessage(_auth.currentUser!.email!, widget.account.getEmail, "Test");
            },
            child: Text("Send Message"),
          ),
        ],
      ),
    );
  }
}
