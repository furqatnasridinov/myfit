import 'package:myfit/infrastructure/models/data/subscribtion_demo.dart';
import 'package:myfit/infrastructure/models/data/user_subscribtion.dart';
import 'package:myfit/infrastructure/models/response/auth_response.dart';
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
    @Default([]) List<String> knownActivities,
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
    @Default(false) bool isNoAccessChangingPhoto,
    @Default(null) SubscribtionDemo? selectedSubscribtion,
    @Default(null) UserSubscription? currentSubscribtion,
    @Default(null) UserSubscription? nextSubscribtion,
    @Default([]) List<Subscription> allAvailableSubscriptions,
    @Default(false) bool isChangeSubscribtionLoading,
    @Default("**** **** **** 1234") String cardNumber,
    @Default(false) bool autoRenewal,
  }) = _SettingsState;
  const SettingsState._();
}
