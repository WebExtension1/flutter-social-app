import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/models/message.dart';
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
  List<Message> messages = [];
  bool _isMounted = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    socketService.socket.on("open message", (data) {
      if (!_isMounted) return;
      setState(() {
        messages = List<Message>.from(
          data.map((post) => Message.fromJson(post))
        );
      });

      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
    socketService.openMessage(_auth.currentUser!.email!, widget.account.getEmail);
    socketService.socket.on("chat message", (data) {
      if (!_isMounted) return;
      if((data['senderEmail'] == _auth.currentUser?.email && data['receiverEmail'] == widget.account.getEmail) || (data['receiverEmail'] == _auth.currentUser?.email && data['senderEmail'] == widget.account.getEmail)) {
        setState(() {
          messages.add(Message(
            messageID: int.tryParse(data['messageID'].toString()) ?? 0,
            content: data['content'],
            sentDate: DateTime.parse(data['sentDate']),
            senderEmail: data['senderEmail'],
            receiverEmail: data['receiverEmail'],
          ));
        });

        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    socketService.socket.off("chat message");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.senderEmail == _auth.currentUser?.email;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          msg.getSentDate,
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    socketService.sendMessage(
                      _auth.currentUser!.email!,
                      widget.account.getEmail,
                      _messageController.text.trim(),
                    );
                    _messageController.clear();
                  }
                },
                child: Text("Send"),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
