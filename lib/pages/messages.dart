import 'package:flutter/material.dart';
import 'package:badbook/widgets/message_preview.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages")
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: dataService.getFriends,
                child: ListView.builder(
                itemCount: dataService.friends.length,
                itemBuilder: (context, index) {
                  return MessagePreview(account: dataService.friends[index]);
                },
              )
            )
          )
        ],
      )
    );
  }
}