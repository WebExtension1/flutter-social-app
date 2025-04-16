import 'package:flutter/material.dart';

// Models
import 'package:untitled/models/account.dart' as account_model;

// Widgets
import 'package:untitled/widgets/friend_preview.dart';
import 'package:untitled/widgets/tab_bar.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:untitled/providers/shared_data.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  int displayType = 1;
  final List<String> labels = ['Friends', 'Contacts', 'Mutual', 'Incoming', 'Outgoing'];

  @override
  void initState() {
    super.initState();
  }

  static Expanded ListViewGroup(List<account_model.Account> group, String type) {
    return Expanded(
      child: ListView.builder(
        itemCount: group.length,
        itemBuilder: (context, index) {
          return FriendPreview(account: group[index], type: type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    final Map<int, Widget> tabContentMap = {
      1: ListViewGroup(dataService.friends, 'Friends'),
      2: ListViewGroup(dataService.contacts, 'Other'),
      3: ListViewGroup(dataService.mutual, 'Other'),
      4: ListViewGroup(dataService.incoming, 'Incoming'),
      5: ListViewGroup(dataService.outgoing, 'Outgoing'),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends")
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          TabBarWidget(
            labels: labels,
            displayType: displayType,
            onTabSelected: (int type) {
              setState(() {
                displayType = type;
              });
            },
          ),
          SizedBox(height: 10),
        tabContentMap[displayType] ?? SizedBox.shrink()
        ],
      )
    );
  }
}