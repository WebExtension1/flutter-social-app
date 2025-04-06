import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/pages/profile.dart';

class AccountPreview extends StatefulWidget {
  const AccountPreview({super.key, required this.account});
  final Account account;

  @override
  State<AccountPreview> createState() => _AccountPreviewState();
}

class _AccountPreviewState extends State<AccountPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: openProfile,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 30),
            SizedBox(height: 8),
            Text('@${widget.account.getUsername}'),
          ],
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
