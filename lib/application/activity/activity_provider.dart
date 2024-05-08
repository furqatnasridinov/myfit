import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_state.dart';
import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/schedule/schedule_provider.dart';
import 'package:myfit/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>(
  (ref) => ActivityNotifier(gymRepo, ref.read(scheduleProvider.notifier), ref.read(main2Provider.notifier), ref.read(mapProvider.notifier))  ,
);
