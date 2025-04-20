import 'package:flutter/material.dart';

// Pages
import 'package:badbook/pages/profile.dart';

// Models
import 'package:badbook/models/account.dart';

// APIs
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountBar extends StatefulWidget {
  const AccountBar({super.key, required this.account, required this.clickable});
  final Account account;
  final bool clickable;

  @override
  State<AccountBar> createState() => _AccountBarState();
}

class _AccountBarState extends State<AccountBar> {
  String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: openProfile,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.account.getImageUrl != null
                  ? NetworkImage("$apiUrl${widget.account.getImageUrl}")
                  : null,
                child: widget.account.getImageUrl == null
                  ? const Icon(Icons.person)
                  : null,
              ),
              const SizedBox(width: 10),
              // https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double maxTextWidth = screenWidth - 270;

                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxTextWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.account.getName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.account.getUsername,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openProfile() async {
    if (widget.clickable) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(account: widget.account)),
      );
    }
  }
}
