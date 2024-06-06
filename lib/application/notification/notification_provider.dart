

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/notification/notification_notifier.dart';
import 'package:myfit/application/notification/notification_state.dart';
import 'package:myfit/domain/di/dependency_manager.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(notificationRepo),
);
