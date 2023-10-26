import 'package:activity/application/gym/gym_notifier.dart';
import 'package:activity/application/gym/gym_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gymProvider = StateNotifierProvider<GymNotifier, GymState>(
  (ref) => GymNotifier(gymRepo),
);
