import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Reply",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            child: TextField(
              maxLines: null,
              maxLength: 750,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Write your reply...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Send"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
