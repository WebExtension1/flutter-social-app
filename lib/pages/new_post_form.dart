import 'package:flutter/material.dart';

// Models
import 'package:badbook/models/feedback_message.dart';

// APIs
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

// Images
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Location
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_settings/app_settings.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final TextEditingController _contentController = TextEditingController();
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  String? visibility = "public";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _locationName;
  FeedbackMessage? message;

  final Map<String, String> visibilityMap = {
    "Public": "public",
    "Friends": "friends",
    "Private": "private",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new post")
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Visibility"),
                const SizedBox(width: 10),
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
            const SizedBox(height: 10),
            if (_locationName != null)
              Text("📍 $_locationName", style: TextStyle(color: Colors.blue)),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _getLocation,
                  icon: const Icon(Icons.location_on),
                  label: const Text("Check in"),
                ),
                if (_locationName != null)
                  TextButton(
                    onPressed: _removeLocation,
                    child: const Text("Remove"),
                  ),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
              ],
            ),
            if (_imageFile != null) ...[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text("Image attached", style: TextStyle(color: Colors.green)),
                        const SizedBox(width: 10),
                        Image.file(_imageFile!, width: 50, height: 50, fit: BoxFit.cover),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _removeImage,
                    child: const Text("Remove"),
                  ),
                ]
              )
            ],
            ElevatedButton(
              onPressed: _createPost,
              child: const Text("Post"),
            ),
            if (message != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message!.message,
                  style: TextStyle(color: message!.getColour),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location services are disabled on your phone.")));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      _showLocationPermissionDialog(context);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _locationName = "${place.name}, ${place.locality}";
      });
    }
  }

  // https://api.flutter.dev/flutter/material/showDialog.html
  void _showLocationPermissionDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text("Please enable location sharing in the app settings."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Go to Settings"),
            ),
          ],
        );
      },
    ).then((goToSettings) {
      if (goToSettings == true) {
        AppSettings.openAppSettings();
      }
    });
  }

  Future<void> _removeLocation() async {
    setState(() {
      _locationName = null;
    });
  }

  void _createPost() async {
    final dataService = Provider.of<DataService>(context, listen: false);

    if (_contentController.text.trim().isNotEmpty || _locationName != null || _imageFile != null) {
      final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/post/create'));
      request.fields['email'] = dataService.user!.getEmail;
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
        dataService.getFeed();
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() {
          message = FeedbackMessage(message: 'Unable to create post.', type: MessageType.error);
        });
      }
    }
    else {
      setState(() {
        message = FeedbackMessage(message: 'Post must contain text, image, or location.', type: MessageType.error);
      });
    }
  }
}
