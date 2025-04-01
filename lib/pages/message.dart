import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.account});
  final Account account;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SMS Advanced Example")),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: (){},
              child: Text("Send SMS"),
            ),
          ],
        ),
      ),
    );
  }
}
