import 'package:myfit/application/schedule/schedule_notifier.dart';
import 'package:myfit/application/schedule/schedule_state.dart';
import 'package:myfit/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, ScheduleState>(
  (ref) => ScheduleNotifier(scheduleRepo),
);
