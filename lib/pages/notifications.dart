import 'package:flutter/material.dart';
import 'package:untitled/services/notifications_services.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification & Camera App"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                children: [
                  Text(
                    "Notifications",
                    style:
                    TextStyle(fontSize: 20, fontFamily: 'Times New Roman'),
                  ),
                  Icon(
                    Icons.notification_add,
                    size: 175,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        await NotificationServices.displayNotification(
                          notificationTitle: "Breaking News",
                          notificationBody: "Football stuff"
                        );
                      },
                      label: Text("Basic Notification"),
                      icon: Icon(Icons.notification_add)),
                  ElevatedButton.icon(
                      onPressed: () {},
                      label: Text("Summary Notification"),
                      icon: Icon(Icons.notification_add)),
                  ElevatedButton.icon(
                      onPressed: () {},
                      label: Text("Scheduled Notification"),
                      icon: Icon(Icons.notification_add)),
                  ElevatedButton.icon(
                      onPressed: () {},
                      label: Text("Action Notification"),
                      icon: Icon(Icons.notification_add)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  Text(
                    "Camera and Photo Gallery",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.camera,
                    size: 200,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Camera and Photo Gallery"),
                    icon: Icon(Icons.camera),
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
