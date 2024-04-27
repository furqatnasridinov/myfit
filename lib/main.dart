import 'package:activity/app_widget.dart';
import 'package:activity/infrastructure/firebase/cloud_messaging.dart';
import 'package:activity/infrastructure/firebase/firebase_options.dart';
import 'package:activity/infrastructure/local_notifications/notification_service.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.getSharedPreferences();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CloudMessaging().initialize();
  tz.initializeTimeZones(); // for scheduled local notifications 
  await LocalNotificationService().initLocalNotification();

  runApp(
    ProviderScope(
      child: AppWidget(),
    ),
  );
}

