import 'package:flutter/services.dart';
import 'package:myfit/app_widget.dart';
import 'package:myfit/domain/di/dependency_manager.dart';
import 'package:myfit/infrastructure/firebase/cloud_messaging.dart';
import 'package:myfit/infrastructure/firebase/firebase_options.dart';
import 'package:myfit/infrastructure/local_notifications/notification_service.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();
  await LocalStorage.getSharedPreferences();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CloudMessaging().initialize();
  tz.initializeTimeZones(); // for scheduled local notifications
  await LocalNotificationService().initLocalNotification();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
     //systemNavigationBarColor:AppColors.backgroundColor,//Colors.white,
    ),
  );

  runApp(
    ProviderScope(
      child: AppWidget(),
    ),
  );
}
