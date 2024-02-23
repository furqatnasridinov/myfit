import 'package:activity/application/settings/settings_state.dart';
import 'package:activity/domain/interface/settings.dart';
import 'package:activity/infrastructure/local_notifications/notification_service.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart';

import '../../infrastructure/models/response/auth_response.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._settingsRepositoryInterface)
      : super(const SettingsState());
  final SetttingsRepositoryInterface _settingsRepositoryInterface;

  void setUserInfos() {
    setPhone();
    setName();
    setSelectedCity();
    setAge();
    setWeight();
    setHeight();
    setNotificationTime(LocalStorage.getReminderTime());
    getReminderDisabledOrEnabled();
  }

  void cityTextFieldRequestFocus() {
    state = state.copyWith(cityTextFieldHasFocus: true);
  }

  void cityTextFieldUnfocus() {
    state = state.copyWith(cityTextFieldHasFocus: false);
  }

  void setSelectedCity() {
    state = state.copyWith(
      selectedCity: LocalStorage.getSelectedCity(),
    );
  }

  Future<void> getListOfCities(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isCitiesLoading: true);
      final response = await _settingsRepositoryInterface.getListOfCities();
      response.when(
        success: (data) {
          if (data['operationResult'] == "OK") {
            final listToCollect = <City>[];
            final dataObject = data["object"];
            for (var element in dataObject) {
              final city = City.fromJson(element);
              listToCollect.add(city);
            }
            state = state.copyWith(
              listOfCities: listToCollect,
              isCitiesLoading: false,
            );
          }
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isCitiesLoading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchName(String? name, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"firstName": name};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchCity(City? city, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"city": city?.toJson()};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchAge(String? age, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"age": age};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchWeight(String? weight, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"weight": weight};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchHeight(String? height, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"height": height};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchGender(String? gender, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"gender": gender};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchAvatar(String? avatar, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"backgroundPictureUrl": avatar};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statuscode) {
          AppHelpers.showErrorSnack(context, "$error $statuscode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void showDefaultNotification() async {
    PermissionStatus permissionStatus = await Permission.notification.request();
    if (permissionStatus.isGranted) {
      NotificationService().showDefaultNotification(
        "Myfit App",
        "Шерзоди пачак",
      );
    } else {
      //await Permission.notification.request();
    }
  }

  void showScheduledNotification({required DateTime time}) async {
    if (!state.isReminderDisabled) {
      PermissionStatus permissionStatus =
          await Permission.notification.request();
      if (permissionStatus.isGranted) {
        final userReminder = state.reminderTime == ""
            ? LocalStorage.getReminderTime()
            : state.reminderTime;
        final duration = getDurationFromReminderTime(userReminder);
        final scheduledTime =
            time.subtract(duration ?? const Duration(minutes: 30));
        NotificationService().showScheduledNotification(
          title: "Myfit App",
          body: "Скоро начнется ваше занятие ",
          dateTime: scheduledTime,
        );
      } else {
        //AppHelpers.showSnack(context, "Разрешение не дано!");
      }
    }
  }

  Duration? getDurationFromReminderTime(String time) {
    if (time == "30") {
      return const Duration(minutes: 30);
    }
    if (time == "1") {
      return const Duration(hours: 1);
    }
    if (time == "2") {
      return const Duration(hours: 2);
    } else {
      return null;
    }
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

  void setNotificationTime(String time) {
    if (state.isReminderDisabled) {
      enableReminder();
    }
    state = state.copyWith(reminderTime: time);
    LocalStorage.setReminderTime(time);
  }

  void disableReminder() {
    state = state.copyWith(isReminderDisabled: true);
    LocalStorage.setReminderDisabled(true);
  }

  void enableReminder() {
    state = state.copyWith(isReminderDisabled: false);
    LocalStorage.setReminderDisabled(false);
  }

  void getReminderDisabledOrEnabled() {
    if (LocalStorage.isReminderDisabled()) {
      state = state.copyWith(isReminderDisabled: true);
    } else {
      state = state.copyWith(isReminderDisabled: false);
    }
  }
}
