import 'package:activity/app_widget.dart';
import 'package:activity/infrastructure/local_notifications/notification_service.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.getSharedPreferences();
  tz.initializeTimeZones();
  await NotificationService().initLocalNotification();

  runApp(
    ProviderScope(
      child: AppWidget(),
    ),
  );
}