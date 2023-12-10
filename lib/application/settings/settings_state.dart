import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isloading,
    @Default(false) bool cityTextFieldHasFocus,
    @Default("") String phoneNumber,
    @Default("") String selectedCity,
    @Default("") String userName,
    @Default("") String age,
    @Default("") String weight,
    @Default("") String height,
    @Default(false) bool isPhoneEditModeEnabled,
    @Default(false) bool isEmailEditModeEnabled,
  }) = _SettingsState;
  const SettingsState._();
}