import 'package:myfit/application/settings/settings_notifier.dart';
import 'package:myfit/application/settings/settings_state.dart';
import 'package:myfit/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(settingsRepo),
);
