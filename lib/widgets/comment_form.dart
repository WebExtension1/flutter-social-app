import 'package:flutter/material.dart';

// APIs
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({super.key, required this.postID});
  final int postID;

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController _contentController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Reply",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: TextField(
              maxLines: null,
              maxLength: 750,
              keyboardType: TextInputType.multiline,
              controller: _contentController,
              decoration: InputDecoration(
                hintText: "Write your reply...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: createMessage,
                child: const Text("Send"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void createMessage () async {
    final response = await http.post(
      Uri.parse('$apiUrl/comment/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'content': _contentController.text, 'postID': widget.postID}),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;

      final dataService = Provider.of<DataService>(context, listen: false);
      dataService.getComments(widget.postID);

      Navigator.pop(context);
    } else {
      setState(() {
      });
    }
  }
}
