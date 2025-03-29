import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final TextEditingController _contentController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> visibilities = [
    "Public", "Friends", "Private"
  ];

  String? visibility = "Public";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Create a new post")
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text("Visibility"),
                SizedBox(width: 10),
                DropdownButton(
                  value: visibility,
                  items: visibilities.map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString())
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      visibility = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Flexible(
              child: TextField(
                maxLines: null,
                maxLength: 2500,
                keyboardType: TextInputType.multiline,
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Write your post...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () { },
                  icon: Icon(Icons.image),
                  label: Text("Upload"),
                ),
                ElevatedButton(
                  onPressed: createPost,
                  child: Text("Post"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void createPost () async {
    final response = await http.post(
      Uri.parse('$apiUrl/post/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'content': _contentController.text  }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, "popped");
    } else {
      setState(() {
      });
    }
  }
}
