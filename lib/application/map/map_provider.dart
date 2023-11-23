import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(mainRepo),
);
