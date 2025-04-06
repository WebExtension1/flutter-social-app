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
    Account(accountID: 1, email: 'user1@email.com', phoneNumber: 12433352352, username: "firstuser", fname: "first", lname: 'user', dateJoined: DateTime.now()),
    Account(accountID: 2, email: 'user2@email.com', phoneNumber: 12433352352, username: "seconduser", fname: "second", lname: 'user', dateJoined: DateTime.now()),
    Account(accountID: 3, email: 'user3@email.com', phoneNumber: 12433352352, username: "thirduser", fname: "third", lname: 'user', dateJoined: DateTime.now()),
    Account(accountID: 4, email: 'user4@email.com', phoneNumber: 12433352352, username: "fourthuser", fname: "fourth", lname: 'user', dateJoined: DateTime.now()),
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