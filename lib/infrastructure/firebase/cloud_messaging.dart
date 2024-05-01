// ignore_for_file: unused_local_variable

import 'package:myfit/infrastructure/local_notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  final String textMessage = message.notification?.body ?? "";
    if (textMessage.isNotEmpty) {
      if (textMessage.contains("через 15 минут")) {
       // getIt<AppRouter>().push(const QrCodeRoute());
      }
    }
}

class CloudMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    debugPrint("handleMessage: $message");
    final String textMessage = message.notification?.body ?? "";
    if (textMessage.isNotEmpty) {
      if (textMessage.contains("через 15 минут")) {
       // getIt<AppRouter>().push(const QrCodeRoute());
      }
    }
  }

  Future initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // triggers when app was in terminated state and user taps on the notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleMessage(message);
      }
    });
    
    // triggers when app is in background and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // triggers when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notif = message.notification;
      LocalNotificationService().showDefaultNotification(notif?.title ?? "null", notif?.body ?? "null");
    });
  }

  Future<void> initialize() async {
    final NotificationSettings permissionSettings = await _firebaseMessaging.requestPermission();
    initPushNotification();
  }
}
