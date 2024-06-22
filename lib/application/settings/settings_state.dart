//import 'package:myfit/infrastructure/models/data/user_instance.dart';


import 'package:flutter/cupertino.dart';
import 'package:myfit/infrastructure/models/data/promocode.dart';
import 'package:myfit/infrastructure/models/data/user_subscribtion.dart';
import 'package:myfit/infrastructure/models/response/auth_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../infrastructure/models/data/referal.dart';
import '../../infrastructure/models/data/user_instance.dart';
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
    @Default("") String gender,
    @Default("") String birthday,
    @Default(false) bool isPhoneEditModeEnabled,
    @Default(false) bool isEmailEditModeEnabled,
    @Default("30") String reminderTime,
    @Default(null) UserInstance? user,
    @Default(false) bool isReminderDisabled,
    @Default("") String? qrcodeValue,
    @Default(false) bool isNoAccessChangingPhoto,
    @Default(false) bool isPhotoUploading,
    @Default(null) UserSubscription? currentSubscribtion,
    @Default(null) UserSubscription? nextSubscribtion,
    @Default([]) List<Subscription> allAvailableSubscriptions,
    @Default(false) bool allSubsLoading,
    @Default(0) int bonusSubsLength,
    TextEditingController? promocodeController,
    @Default(false) bool isChangeSubscribtionLoading,
    @Default("**** **** **** 1234") String cardNumber,
    @Default(false) bool autoRenewal,
    @Default(false) bool dropDownOpened,
    @Default(false) bool genderDropDownOpened,
    @Default([]) List<String> missingInfo,
    @Default("") String promocodeValue,
    @Default(false) bool isPromocodeLoading,
    @Default([]) List<Promocode> promocodesHistory,
    @Default([]) List<Promocode> promocodesQueue,
    @Default(false) bool isPromocodeSuccess,
    @Default(false) bool isPromocodeError,
    @Default("") String promocodeErrorMessage,
    @Default("") String newPromocodeDescription,
    @Default(null) Referal? referalInfo,
    @Default(false) bool referalInfoLoading,
    @Default(false) takeBonusButtonClicked,
  }) = _SettingsState;
  const SettingsState._();
}
