import 'dart:io';

import 'package:activity/infrastructure/local_notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

class CloudMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    debugPrint("handleMessage: $message");
    // Handle the message here, for exmaple 
    // context.router.pushNamed('/notification');
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
    // ignore: unused_local_variable
    final NotificationSettings permissionSettings = await _firebaseMessaging.requestPermission();
    /* if (Platform.isAndroid) {
      // remove platform check in future when i get developer account
        final fcmToken = await _firebaseMessaging.getToken();
        debugPrint('FCM Token: $fcmToken');
    } */
    initPushNotification();
  }
}
