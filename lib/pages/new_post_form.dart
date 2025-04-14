import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  String? _locationName;

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
                    value: entry.value,
                    child: Text(entry.key),
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
            if (_locationName != null)
              Text("📍 $_locationName", style: TextStyle(color: Colors.blue)),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _getLocation,
                  icon: Icon(Icons.location_on),
                  label: Text("Check in"),
                ),
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

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location services are disabled.")));
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location permission denied.")));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location permission permanently denied.")));
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _locationName = "${place.name}, ${place.locality}";
      });
    }
  }

  void createPost () async {
    final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/post/create'));
    request.fields['email'] = _auth.currentUser!.email!;
    request.fields['content'] = _contentController.text;
    request.fields['visibility'] = visibility!;
    if (_locationName != null) {
      request.fields['location'] = _locationName!;
    }

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context, "popped");
    } else {
      setState(() {});
    }
  }
}
