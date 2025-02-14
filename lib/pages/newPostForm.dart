import 'package:flutter/material.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
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
                  onPressed: () {

                  },
                  icon: Icon(Icons.image),
                  label: Text("Upload"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Post"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
