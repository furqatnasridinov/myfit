/* import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings("default_icon"),
      iOS: DarwinInitializationSettings(
          /* requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false, 
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,*/
          ),
    );
    await notificationPlugin.initialize(initSettings);
  }

  void showDefaultNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'tmpChannelId' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    notificationPlugin.show(1, title, body, notificationDetails);
  }

  void showScheduledNotification({
    int id = AppConstants.scheduledNotificationId,
    String? title,
    String? body,
    required DateTime dateTime,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      AppConstants.scheduledNotificationChannelId,
      AppConstants.scheduledNotificationChannelName,
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = const DarwinNotificationDetails(
        //sound: "tmpSoundName"
        );
    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    return notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        dateTime,
        tz.local,
      ),
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      //payload: Дополнительная строка, которая может быть передана в уведомление
      //для дальнейшей обработки, когда пользователь взаимодействует с
      //уведомлением.
    );
  }

  Future<List<PendingNotificationRequest>> showActiveNotification() async {
    final List<PendingNotificationRequest> activeNotifications =
        await notificationPlugin.pendingNotificationRequests();
    debugPrint(activeNotifications.toString());
    return activeNotifications;
  }

  void cancelNotification() async {
    await notificationPlugin.cancel(AppConstants.scheduledNotificationId);
  }
}
 */