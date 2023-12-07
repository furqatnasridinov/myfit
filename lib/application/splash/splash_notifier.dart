import 'package:activity/application/splash/splash_state.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState());

  Future<void> checkUserIfExists(
    BuildContext context, {
    VoidCallback? goMain,
    VoidCallback? goLogin,
  }) async {
    if (await LocalStorage.checkIfIsNotEmpty()) {
      goMain?.call();
    } else {
      goLogin?.call();
    }
  }
}
