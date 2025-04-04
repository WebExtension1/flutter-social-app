import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:intl/intl.dart';
import 'package:untitled/pages/message.dart';

class MessagePreview extends StatefulWidget {
  const MessagePreview({super.key, required this.account});
  final Account account;

  @override
  State<MessagePreview> createState() => _MessagePreviewState();
}

class _MessagePreviewState extends State<MessagePreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayMessages(false);
      },
      child:  Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(),
              SizedBox(width: 10),
              Column(
                children: [
                  Text(widget.account.getUsername),
                  Text("Last Message")
                ],
              ),
              Spacer(),
              Text("${DateFormat('yyyy-MM-dd').format(DateTime.now())} at ${DateFormat('hh:mm').format(DateTime.now())}")
            ],
          ),
        )
      )
    );
  }

  void displayMessages(bool commentToSend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePage(account: widget.account)),
    );
  }
}
