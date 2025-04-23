import 'package:flutter/material.dart';

// Notifications
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationServices {
  static Future<void> initialiseNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "messages_channel",
          channelName: "Messages",
          channelGroupKey: "messages_group",
          channelDescription: "Receive notifications when you receive a message",
          defaultColor: Color(0xFF007788),
          importance: NotificationImportance.High,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: false,
        ),
        NotificationChannel(
          channelKey: "memories_channel",
          channelName: "Memories",
          channelGroupKey: "memories_group",
          channelDescription: "Receive daily notifications about your memories",
          defaultColor: Color(0xFF007788),
          importance: NotificationImportance.Default,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: false,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
        channelGroupKey: "messages_group",
        channelGroupName: "Messages"
        ),
        NotificationChannelGroup(
          channelGroupKey: "memories_group",
          channelGroupName: "Memories"
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("User Action Received");
  }

  static Future<void> displayNotification({
    required final String notificationTitle,
    required final String notificationBody,
    final String? notificationSummary,
    final Map<String, String>? notificationPayload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final List<NotificationActionButton>? actionButtons,
    final bool notificationScheduled = false,
    final Duration? notificationDuration
  }) async {
    assert(!notificationScheduled || (notificationScheduled && notificationDuration != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "memories_channel",
        title: notificationTitle,
        body: notificationBody,
        summary: notificationSummary,
        payload: notificationPayload,
        actionType: actionType,
        notificationLayout: notificationLayout,
      ),
      actionButtons: actionButtons,
      schedule: notificationScheduled ? NotificationInterval(
        interval: notificationDuration,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true
      ): null
    );
  }
}