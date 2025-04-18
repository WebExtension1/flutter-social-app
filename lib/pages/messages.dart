import 'package:flutter/material.dart';
import 'package:untitled/widgets/message_preview.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:untitled/providers/shared_data.dart';

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
        title: Text("Messages")
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: dataService.friends.length,
              itemBuilder: (context, index) {
                return MessagePreview(account: dataService.friends[index]);
              },
            )
          )
        ],
      )
    );
  }
}