import 'package:activity/application/settings/settings_notifier.dart';
import 'package:activity/application/settings/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
