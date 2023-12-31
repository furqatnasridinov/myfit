import 'package:activity/application/registration/registration_notifier.dart';
import 'package:activity/application/registration/registration_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>(
  (ref) => RegistrationNotifier(registerRepo),
);
