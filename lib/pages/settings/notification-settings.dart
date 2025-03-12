import 'package:flutter/material.dart';
import 'package:untitled/services/notifications_services.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Settings"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await NotificationServices.displayNotification(
                        notificationTitle: "Breaking News",
                        notificationBody: "The King Died :("
                      );
                    },
                    label: Text("Basic Notification"),
                    icon: Icon(Icons.notification_add)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
