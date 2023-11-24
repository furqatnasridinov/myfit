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
  static void removeUserName() => _preferences?.remove(AppConstants.keyUserName);
}
