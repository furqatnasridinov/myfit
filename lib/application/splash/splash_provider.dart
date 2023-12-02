import 'package:activity/application/splash/splash_notifier.dart';
import 'package:activity/application/splash/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashprovider = StateNotifierProvider<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(),
);
