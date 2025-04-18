import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/pages/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessagePreview extends StatefulWidget {
  const MessagePreview({super.key, required this.account});
  final Account account;

  @override
  State<MessagePreview> createState() => _MessagePreviewState();
}

class _MessagePreviewState extends State<MessagePreview> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayMessages(false);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.account.getImageUrl != null
                    ? NetworkImage("$apiUrl${widget.account.getImageUrl!}")
                    : null,
                child: widget.account.getImageUrl == null
                    ? Icon(Icons.person)
                    : null,
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text(widget.account.getName),
                ],
              ),
            ],
          ),
        )
      )
    );
  }

  void displayMessages(bool commentToSend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(account: widget.account),
      )
    );
  }
}
