import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainProvider = StateNotifierProvider<MainNotifier, MainState>(
  (ref) => MainNotifier(mainRepo),
);
