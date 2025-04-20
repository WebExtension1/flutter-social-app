import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/message.dart';

// Models
import 'package:badbook/models/account.dart';

// Widgets
import 'package:badbook/widgets/account_bar.dart';

// APIs
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
          child: AccountBar(account: widget.account, clickable: false),
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
