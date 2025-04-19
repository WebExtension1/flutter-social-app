import 'package:flutter/material.dart';

// Profile
import 'package:badbook/pages/profile.dart';

// Models
import 'package:badbook/models/account.dart';
import 'package:badbook/models/message.dart';

// Widgets
import 'package:badbook/widgets/message.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Services
import 'package:badbook/services/socket_service.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

// Firebase
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
  bool _isMounted = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  Future<void> _loadMessages() async {
    final dataService = Provider.of<DataService>(context, listen: false);
    await dataService.getMessageHistory(widget.account.getEmail);
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();

    final dataService = Provider.of<DataService>(context, listen: false);

    socketService.socket.on("chat message", (data) {
      if (!_isMounted) return;

      if (data is List) {
        var item = data[0];

        final sender = item['senderEmail'];
        final receiver = item['receiverEmail'];
        final myEmail = _auth.currentUser?.email;
        final otherEmail = widget.account.getEmail;

        if ((sender == myEmail && receiver == otherEmail) || (receiver == myEmail && sender == otherEmail)) {
          if (!mounted) return; // extra safety
          setState(() {
            dataService.messages[widget.account.getEmail]!.add(Message(
              messageID: int.tryParse(item['messageID'].toString()) ?? 0,
              content: item['content'],
              sentDate: DateTime.parse(item['sentDate']),
              senderEmail: sender,
              receiverEmail: receiver,
            ));
          });
          scrollToBottom();
        }
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
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.getName),
        actions: [
          GestureDetector(
            onTap: _openProfile,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.account.getImageUrl != null
                ? NetworkImage("$apiUrl${widget.account.getImageUrl!}")
                : null,
              child: widget.account.getImageUrl == null
                ? const Icon(Icons.person)
                : null,
            )
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          dataService.messages[widget.account.getEmail] != null ?
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: dataService.messages[widget.account.getEmail]!.length,
                itemBuilder: (context, index) {
                  final message = dataService.messages[widget.account.getEmail]![index];
                  return MessageWidget(message: message);
                },
              )
            ) : const Center(child: CircularProgressIndicator()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        socketService.sendMessage(
                          widget.account.getEmail,
                          _messageController.text.trim(),
                        );
                        _messageController.clear();
                      }
                    },
                    child: const Text("Send"),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  void _openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(account: widget.account)),
    );
  }
}
