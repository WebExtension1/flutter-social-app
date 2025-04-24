import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Images
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newFNameController = TextEditingController();
  final TextEditingController _newLNameController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  FeedbackMessage? usernameMessage;
  FeedbackMessage? nameMessage;
  FeedbackMessage? profilePictureMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            const Divider(),
            const Text(
              "Change Profile Picture",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Upload"),
            ),
            if (profilePictureMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  profilePictureMessage!.getMessage,
                  style: TextStyle(color: profilePictureMessage!.getColour),
                ),
              ),
            ],
            const Divider(),
            const Text(
              "Update Username",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newUsernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateUsername,
              child: const Text('Update'),
            ),
            if (usernameMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  usernameMessage!.getMessage,
                  style: TextStyle(color: usernameMessage!.getColour),
                ),
              ),
            ],
            const Divider(),
            const Text(
              "Update Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: _newFNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _newLNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateName,
              child: const Text('Update'),
            ),
            if (nameMessage != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  nameMessage!.getMessage,
                  style: TextStyle(color: nameMessage!.getColour),
                ),
              ),
            ],
          ],
        )
      )
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/account/updateProfilePicture'));
      request.fields['email'] = _auth.currentUser!.email!;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          profilePictureMessage = FeedbackMessage(message: 'Profile Picture updated!', type: MessageType.success);
        });
      } else {
        setState(() {
          profilePictureMessage = FeedbackMessage(message: "Profile picture couldn't be updated.", type: MessageType.error);
        });
      }
    }
  }

  void _updateUsername() async {
    String newUsername = _newUsernameController.text.trim();

    if (newUsername.isEmpty) {
      setState(() {
        usernameMessage = FeedbackMessage(message: 'Username field cannot be empty.', type: MessageType.error);
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/account/updateUsername'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'username': newUsername}),
    );
    if (response.statusCode == 200) {
      setState(() {
        usernameMessage = FeedbackMessage(message: 'Username updated!', type: MessageType.success);
      });
    } else {
      setState(() {
        usernameMessage = FeedbackMessage(message: 'Unable to update account details.', type: MessageType.error);
      });
    }
  }

  void _updateName() async {
    String newFName = _newFNameController.text.trim();
    String newLName = _newLNameController.text.trim();

    if (newFName.isEmpty  || newLName.isEmpty) {
      setState(() {
        nameMessage = FeedbackMessage(message: 'Name fields cannot be empty.', type: MessageType.error);
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/account/updateName'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'fname': newFName, 'lname': newLName}),
    );
    if (response.statusCode == 200) {
      setState(() {
        nameMessage = FeedbackMessage(message: 'Name updated!', type: MessageType.success);
      });
    } else {
      setState(() {
        nameMessage = FeedbackMessage(message: 'Unable to update account details.', type: MessageType.error);
      });
    }
  }
}
