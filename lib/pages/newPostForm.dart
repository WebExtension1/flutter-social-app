import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final TextEditingController _contentController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? visibility = "public";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final Map<String, String> visibilityMap = {
    "Public": "public",
    "Friends": "friends",
    "Private": "private",
  };

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
                  items: visibilityMap.entries.map((entry) => DropdownMenuItem(
                    value: entry.value, // Store lowercase value
                    child: Text(entry.key), // Display capitalized text
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      visibility = value!;
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
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text("Upload"),
                ),
                if (_imageFile != null)
                  Text("Image uploaded", style: TextStyle(color: Colors.green)),
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void createPost () async {
    final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/post/create'));
    request.fields['email'] = _auth.currentUser!.email!;
    request.fields['content'] = _contentController.text;
    request.fields['visibility'] = visibility!;

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context, "popped");
    } else {
      setState(() {
      });
    }
  }
}
