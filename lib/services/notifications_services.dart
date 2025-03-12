import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  static Future<void> initialiseNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "sports_channel",
          channelName: "Sports News Channel",
          channelGroupKey: "sports_news_group",
          channelDescription: "Latest sports news from around the world",
          defaultColor: Color(0xFFED0099),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: "sports_news_group",
          channelGroupName: "Sports News Update"
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("User Action Received");
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint("Notification Created");
  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint("Notification Displayed");
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("User Dismiss Action Received");
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
    assert(!notificationScheduled || (notificationScheduled && notificationDuration == null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "sports_channel",
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