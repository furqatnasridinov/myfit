import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_state.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    @Default(false) bool isloading,
    @Default(false) bool isPinCodeValidate,
    @Default(false) bool isCodeError,
    @Default(59) int timeToCountDown,
  }) = _RegistrationState;
  const RegistrationState._();
}