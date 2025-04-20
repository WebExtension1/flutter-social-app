import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/profile.dart';

// Models
import 'package:badbook/models/account.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountPreview extends StatefulWidget {
  const AccountPreview({super.key, required this.account});
  final Account account;

  @override
  State<AccountPreview> createState() => _AccountPreviewState();
}

class _AccountPreviewState extends State<AccountPreview> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProfile,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: widget.account.getImageUrl != null
              ? NetworkImage("$apiUrl${widget.account.getImageUrl!}")
              : null,
            child: widget.account.getImageUrl == null
              ? const Icon(Icons.person)
              : null,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              widget.account.getUsername,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
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
