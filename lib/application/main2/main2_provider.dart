import 'package:activity/application/main2/main2_notifier.dart';
import 'package:activity/application/main2/main2_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final main2Provider = StateNotifierProvider<Main2Notifier, Main2State>(
  (ref) => Main2Notifier(scheduleRepo),
);
