import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/profile.dart';

// Models
import 'package:badbook/models/account.dart';

// Widgets
import 'package:badbook/widgets/account_bar.dart';

class FriendPreview extends StatefulWidget {
  const FriendPreview({super.key, required this.account});
  final Account account;

  @override
  State<FriendPreview> createState() => _FriendPreviewState();
}

class _FriendPreviewState extends State<FriendPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProfile,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              AccountBar(account: widget.account, clickable: false),
              Expanded(
                child: SizedBox()
              ),
              if (widget.account.getRelationship == 'friend')
                ElevatedButton(
                  onPressed: () => {widget.account.removeFriend},
                  child: const Text("Remove"),
                ),
              if (widget.account.getRelationship == 'incoming')
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => {widget.account.acceptFriendRequest},
                      child: const Text("Accept"),
                    ),
                    ElevatedButton(
                      onPressed: () => {widget.account.rejectFriendRequest},
                      child: const Text("Reject"),
                    ),
                  ]
                ),
              if (widget.account.getRelationship == 'outgoing')
                ElevatedButton(
                  onPressed: () => {widget.account.cancelFriendRequest},
                  child: const Text("Cancel"),
                ),
              if (widget.account.getRelationship == 'other')
                ElevatedButton(
                  onPressed: () => {widget.account.sendFriendRequest},
                  child: const Text("Send Request"),
                )
            ],
          ),
        )
      )
    );
  }

  void openProfile() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(account: widget.account)),
    );
  }
}
