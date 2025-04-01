import 'package:flutter/material.dart';
import 'package:untitled/services/notifications_services.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationSettings> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  Future<void> requestNotificationPermissions() async {
    await Permission.notification.request();
  }

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
