import 'package:activity/infrastructure/models/data/city_to_select.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isloading,
    @Default(false) bool cityTextFieldHasFocus,
    @Default("") String phoneNumber,
    @Default(null) CityToSelect? selectedCity,
    @Default("") String userName,
    @Default("") String age,
    @Default("") String weight,
    @Default("") String height,
    @Default(false) bool isPhoneEditModeEnabled,
    @Default(false) bool isEmailEditModeEnabled,
  }) = _SettingsState;
  const SettingsState._();
}