import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>(
  (ref) => ActivityNotifier(gymRepo),
);
