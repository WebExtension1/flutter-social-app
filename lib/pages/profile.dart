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
import 'package:badbook/widgets/account_bar.dart';
import 'package:badbook/widgets/tab_bar.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:badbook/providers/shared_data.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, this.account, this.memories});
  final Account? account;
  final bool? memories;

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Account account;
  bool loading = true;
  int displayType = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> labels = ['Posts', 'Comments', 'Liked'];

  @override
  void initState() {
    super.initState();
    final dataService = Provider.of<DataService>(context, listen: false);

    if (widget.account != null) {
      account = widget.account!;
    } else {
      account = dataService.user!;
    }

    if (_auth.currentUser!.email == account.getEmail) {
      labels.add('Memories');
      if (widget.memories == true) {
        setState(() {
          displayType = 4;
        });
      }
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
                AccountBar(account: account, clickable: true),
                const Expanded(
                  child: SizedBox()
                ),
                if (account.getRelationship == 'friend' && account.getEmail != _auth.currentUser!.email)
                  ElevatedButton(
                    onPressed: () => {account.removeFriend(dataService)},
                    child: const Text("Remove"),
                  ),
                if (account.getRelationship == 'incoming' && account.getEmail != _auth.currentUser!.email)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => {account.acceptFriendRequest},
                        child: const Text("Accept"),
                      ),
                      ElevatedButton(
                        onPressed: () => {account.rejectFriendRequest},
                        child: const Text("Reject"),
                      ),
                    ]
                  ),
                if (account.getRelationship == 'outgoing' && account.getEmail != _auth.currentUser!.email)
                  ElevatedButton(
                    onPressed: () => {account.cancelFriendRequest},
                    child: const Text("Cancel"),
                  ),
                if (account.getRelationship == 'other' && account.getEmail != _auth.currentUser!.email)
                  ElevatedButton(
                    onPressed: () => {account.sendFriendRequest},
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
              TabBarWidget(
                labels: labels,
                displayType: displayType,
                onTabSelected: (int type) {
                  setState(() {
                    displayType = type;
                  });
                },
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
                ),
              if (displayType == 4)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDetails,
                    child: ListView.builder(
                      itemCount: dataService.memories.length,
                      itemBuilder: (context, index) {
                        return PostPreview(
                          post: dataService.memories[index],
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
}