import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/settings.dart';

// Models
import 'package:badbook/models/account.dart';
import 'package:badbook/models/comment.dart';
import 'package:badbook/models/post.dart';

// Widgets
import 'package:badbook/widgets/comment_preview.dart';
import 'package:badbook/widgets/post_preview.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, this.account});
  final Account? account;

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Account account;
  bool loading = true;
  int displayType = 1;
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> labels = ['Posts', 'Comments', 'Liked'];

  @override
  void initState() {
    super.initState();
    final dataService = Provider.of<DataService>(context, listen: false);

    if (widget.account != null) {
      account = widget.account!;
    } else {
      account = dataService.user!;
    }

    _loadDetails();
    loading = false;
  }

  Future<void> _loadDetails() async {
    final dataService = Provider.of<DataService>(context, listen: false);
    await dataService.getProfile(account.getEmail);
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          if (account.getEmail == _auth.currentUser?.email)
            IconButton(onPressed: _displaySettings, icon: Icon(Icons.settings))
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: account.getImageUrl != null
                    ? NetworkImage("$apiUrl${account.getImageUrl!}")
                    : null,
                  child: account.getImageUrl == null
                    ? const Icon(Icons.person)
                    : null,
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      account.getName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      account.getUsername,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox()
                ),
                if (account.getRelationship == 'friend')
                  ElevatedButton(
                    onPressed: removeFriend,
                    child: const Text("Remove"),
                  ),
                if (account.getRelationship == 'incoming')
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: acceptFriendRequest,
                        child: const Text("Accept"),
                      ),
                      ElevatedButton(
                        onPressed: rejectFriendRequest,
                        child: const Text("Reject"),
                      ),
                    ]
                  ),
                if (account.getRelationship == 'outgoing')
                  ElevatedButton(
                    onPressed: cancelFriendRequest,
                    child: const Text("Cancel"),
                  ),
                if (account.getRelationship == 'other')
                  ElevatedButton(
                    onPressed: sendFriendRequest,
                    child: const Text("Send Request"),
                  )
              ],
            ),
            if (dataService.profiles[account.getEmail] != null) ...[
              const SizedBox(height: 10),
              Text("Joined ${account.getTimeSinceJoined}"),
              const SizedBox(height: 10),
              Text("${dataService.profiles[account.getEmail]!['posts']!.length} Post${dataService.profiles[account.getEmail]!['posts']!.length != 1 ? 's' : ''}"),
              const SizedBox(height: 10),
              Text("${dataService.profiles[account.getEmail]!['friends']!.length} Friend${dataService.profiles[account.getEmail]!['friends']!.length != 1 ? 's' : ''}"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(labels.length, (index) {
                      final int type = index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              displayType = type;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                labels[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                height: 2,
                                width: displayType == type ? 24 : 0,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 10),
              if (displayType == 1)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDetails,
                    child: ListView.builder(
                      itemCount: dataService.profiles[account.getEmail]!['posts']!.length,
                      itemBuilder: (context, index) {
                        return PostPreview(
                          post: dataService.profiles[account.getEmail]!['posts']!.cast<Post>()[index],
                          account: account
                        );
                      }
                    ),
                  )
                ),
              if (displayType == 2)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDetails,
                    child: ListView.builder(
                      itemCount: dataService.profiles[account.getEmail]!['comments']!.length,
                      itemBuilder: (context, index) {
                        return CommentPreview(
                          comment: dataService.profiles[account.getEmail]!['comments']!.cast<Comment>()[index],
                          onDelete: () {
                            setState(() {
                              dataService.profiles[account.getEmail]!['comments']!.cast<Comment>().removeAt(index);
                            });
                          },
                          displayTop: true,
                          account: account
                        );
                      }
                    ),
                  )
                ),
              if (displayType == 3)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDetails,
                    child: ListView.builder(
                      itemCount: dataService.profiles[account.getEmail]!['liked']!.length,
                      itemBuilder: (context, index) {
                        return PostPreview(
                          post: dataService.profiles[account.getEmail]!['liked']!.cast<Post>()[index],
                          account: account
                        );
                      }
                    ),
                  )
                )
            ]
          ],
        ),
      )
    );
  }

  void _displaySettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const Settings(),
      ),
    );
  }

  void removeFriend() async {
    await http.post(
      Uri.parse('$apiUrl/account/removeFriend'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': account.getEmail}),
    );
  }

  void acceptFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/acceptFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': account.getEmail}),
    );
  }

  void rejectFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/rejectFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': account.getEmail}),
    );
  }

  void cancelFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/cancelFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': account.getEmail}),
    );
  }

  void sendFriendRequest() async {
    await http.post(
      Uri.parse('$apiUrl/account/sendFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': _auth.currentUser?.email, 'otherEmail': account.getEmail}),
    );
  }
}