import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/widgets/messagePreview.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  final List<Account> accounts = [
    Account(username: "First User", tag: "firstuser", dateJoined: DateTime.now()),
    Account(username: "Second User", tag: "seconduser", dateJoined: DateTime.now()),
    Account(username: "Third User", tag: "thirduser", dateJoined: DateTime.now()),
    Account(username: "Fourth User", tag: "fourthuser", dateJoined: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            return MessagePreview(account: accounts[index]);
          },
        ),
      ),
    );
  }
}