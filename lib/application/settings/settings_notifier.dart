import 'package:activity/application/settings/settings_state.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    setPhone();
    setName();
    setSelectedCity();
    setAge();
    setWeight();
    setHeight();
  }

  void cityTextFieldRequestFocus() {
    state = state.copyWith(cityTextFieldHasFocus: true);
  }

  void cityTextFieldUnfocus() {
    state = state.copyWith(cityTextFieldHasFocus: false);
  }

  void setSelectedCity() {
    state = state.copyWith(selectedCity: LocalStorage.getSelectedCity());
  }

  void setPhone() {
    state = state.copyWith(phoneNumber: LocalStorage.getPhoneNumber());
  }

  void setName() {
    state = state.copyWith(userName: LocalStorage.getUserName());
  }

  void setAge() {
    state = state.copyWith(age: LocalStorage.getAge());
  }

  void setWeight() {
    state = state.copyWith(weight: LocalStorage.getWeight());
  }

  void setHeight() {
    state = state.copyWith(height: LocalStorage.getHeight());
  }

  void enableEditingPhone() {
    state = state.copyWith(isPhoneEditModeEnabled: true);
  }

  void closeEditingPhone() {
    state = state.copyWith(isPhoneEditModeEnabled: false);
  }

  void enableEditingEmail() {
    state = state.copyWith(isEmailEditModeEnabled: true);
  }

  void closeEditingEmail() {
    state = state.copyWith(isEmailEditModeEnabled: false);
  }
}
