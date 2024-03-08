import 'package:activity/infrastructure/models/response/auth_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isloading,
    @Default(false) bool isCitiesLoading,
    @Default(false) bool cityTextFieldHasFocus,
    @Default("") String phoneNumber,
    @Default(null) String? selectedCity,
    @Default([]) List<City> listOfCities,
    @Default("") String userName,
    @Default("") String userLastName,
    @Default("") String age,
    @Default("") String weight,
    @Default("") String height,
    @Default("") String avatar,
    @Default(false) bool isPhoneEditModeEnabled,
    @Default(false) bool isEmailEditModeEnabled,
    @Default("30") String reminderTime,
    @Default(false) bool isReminderDisabled,
    @Default("") String? qrcodeValue,
  }) = _SettingsState;
  const SettingsState._();
}
