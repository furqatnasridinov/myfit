import 'dart:convert';

import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  LocalStorage._();

  static LocalStorage? _localStorage;

  static LocalStorage instance = LocalStorage._();

  static Future<LocalStorage> getInstance() async {
    if (_localStorage == null) {
      _localStorage = LocalStorage._();
      await _localStorage!._init();
    }
    return _localStorage!;
  }

  static Future<SharedPreferences> getSharedPreferences() async {
    if (_preferences == null) {
      _localStorage = LocalStorage._();
      await _localStorage!._init();
    }
    return _preferences!;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // save phone number
  static Future<void> setPhoneNumber(String? phoneNumber) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyPhoneNumber,
        phoneNumber ?? "??",
      );
    }
  }

  // get phone number
  static String getPhoneNumber() =>
      _preferences?.getString(AppConstants.keyPhoneNumber) ?? "";

  // remove phone number
  static void removePhone() =>
      _preferences?.remove(AppConstants.keyPhoneNumber);

  // save city
  static Future<void> setSelectedCity(String? city) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyCity,
        city ?? "??",
      );
    }
  }

  // get city
  static String getSelectedCity() =>
      _preferences?.getString(AppConstants.keyCity) ?? "";

  // remove city
  static void removeSelectedCity() =>
      _preferences?.remove(AppConstants.keyCity);

  // save age
  static Future<void> setAge(String? age) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyAge,
        age ?? "??",
      );
    }
  }

  // get age
  static String getAge() => _preferences?.getString(AppConstants.keyAge) ?? "0";

  // remove age
  static void removeAge() => _preferences?.remove(AppConstants.keyAge);

  // save weight
  static Future<void> setWeight(String? weight) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyWeight,
        weight ?? "??",
      );
    }
  }

  // get weight
  static String getWeight() =>
      _preferences?.getString(AppConstants.keyWeight) ?? "0";

  // remove weight
  static void removeWeight() => _preferences?.remove(AppConstants.keyWeight);

  // save height
  static Future<void> setHeight(String? height) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyHeight,
        height ?? "??",
      );
    }
  }

  // get height
  static String getHeight() =>
      _preferences?.getString(AppConstants.keyHeight) ?? "0";

  // remove height
  static void removeHeight() => _preferences?.remove(AppConstants.keyHeight);

  // save avatar
  static Future<void> setAvatar(String? avatar) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyAvatar,
        avatar ?? "??",
      );
    }
  }

  // get avatar
  static String getAvatar() =>
      _preferences?.getString(AppConstants.keyAvatar) ?? "";

  // remove avatar
  static void removeAvatar() => _preferences?.remove(AppConstants.keyAvatar);

  // save user id
  static Future<void> setUserId(String? id) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyUserId,
        id ?? "??",
      );
    }
  }

  // get user id
  static String getUserId() =>
      _preferences?.getString(AppConstants.keyUserId) ?? "";

  // remove user id
  static void removeUserId() => _preferences?.remove(AppConstants.keyUserId);

  // save user id
  static Future<void> setToken(String? token) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyToken,
        token ?? "??",
      );
    }
  }

  // get user id
  static String getToken() =>
      _preferences?.getString(AppConstants.keyToken) ?? "";

  // remove user id
  static void removeToken() => _preferences?.remove(AppConstants.keyToken);

  // save user id
  static Future<void> setUserName(String? username) async {
    if (_preferences != null) {
      await _preferences?.setString(
        AppConstants.keyUserName,
        username ?? "??",
      );
    }
  }

  // get user id
  static String getUserName() =>
      _preferences?.getString(AppConstants.keyUserName) ?? "";

  // remove user id
  static void removeUserName() =>
      _preferences?.remove(AppConstants.keyUserName);

  static Future<bool> checkIfIsNotEmpty() async {
    if (getToken().isNotEmpty && getUserId().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // set List<String> ==> knownActivities
  static Future<void> setKnownActivities(List<String> list) async {
    String convertedToJson = jsonEncode(list);
    if (_preferences != null) {
      await _preferences?.setString(
          AppConstants.keyKnownActivities, convertedToJson);
    }
  }

  // get List<String> ==> knownActivities
  static List<String> getKnownActivities() {
    String? jsonString =
        _preferences?.getString(AppConstants.keyKnownActivities);
    if (jsonString != null) {
      return List<String>.from(jsonDecode(jsonString));
    } else {
      return [];
    }
  }

  // remove List<String> ==> knownActivities
  static void removeKnownActivities() =>
      _preferences?.remove(AppConstants.keyUserName);
}
