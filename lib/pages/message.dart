import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/models/message.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.account});
  final Account account;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late List<Message> messages;

  @override
  void initState() {
    super.initState();
    messages = [
      Message(content: "Hi!", sentDate: DateTime.now(), account: widget.account)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.getUsername),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return (
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(messages[index].getContent),
              ),
            )
          );
        },
      ),
    );
  }
}
