// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:myfit/application/settings/settings_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/settings.dart';
import 'package:myfit/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:myfit/infrastructure/models/request/send_phone_number_request.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../infrastructure/models/data/user_subscribtion.dart';
import '../../infrastructure/models/response/auth_response.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._settingsRepositoryInterface)
      : super(const SettingsState());
  final SetttingsRepositoryInterface _settingsRepositoryInterface;

  void setUserInfos() {
    setPhone();
    setName();
    setLastname();
    setSelectedCity();
    setAge();
    setWeight();
    setHeight();
    setAvatar();
    getAccessPhotoUpload();
    if (!LocalStorage.isReminderDisabled()) {
      setNotificationTime(LocalStorage.getReminderTime());
    }
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

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      //await openAppSettings();
    }
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isCitiesLoading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void getAccessPhotoUpload() {
    final DateTime whenAccessUploadingPhotoOpens =
        DateTime.parse(LocalStorage.getWhenUploadingPhotoOpens());
    final bool resultBool =
        DateTime.now().isBefore(whenAccessUploadingPhotoOpens);
    state = state.copyWith(isNoAccessChangingPhoto: resultBool);
  }

  Future<void> getCompletedLessonTypes(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response =
          await _settingsRepositoryInterface.getCompletedLessonTypes();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final knownActivities = <String>[];
            knownActivities.addAll(state.knownActivities);
            for (var element in listFromServer) {
              try {
                if (!knownActivities.contains(element)) {
                  knownActivities.add(element.toString());
                }
              } catch (e) {
                rethrow;
              }
            }
            state = state.copyWith(knownActivities: knownActivities);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getWaitingLessonTypes(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response =
          await _settingsRepositoryInterface.getWaitingLessonTypes();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final knownActivities = <String>[];
            knownActivities.addAll(state.knownActivities);
            for (var element in listFromServer) {
              try {
                if (!knownActivities.contains(element)) {
                  knownActivities.add(element.toString());
                }
              } catch (e) {
                rethrow;
              }
            }
            state = state.copyWith(knownActivities: knownActivities);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
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
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setUserName(data["object"]["firstName"]);
            setName();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchLastname(String? lastName, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"lastName": lastName};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setUserLastName(data["object"]["lastName"]);
            setLastname();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
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
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setSelectedCity(data["object"]["city"]["name"]);
            await LocalStorage.setSelectedCityLat(
                data["object"]["city"]["latitude"]);
            await LocalStorage.setSelectedCityLon(
                data["object"]["city"]["longitude"]);
            setSelectedCity();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
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
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setAge(data["object"]["age"].toString());
            setAge();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
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
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setWeight(data["object"]["weight"].toString());
            setWeight();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
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
        success: (data) async {
          // no need to return we are saving locally
          if (data["operationResult"] == "OK") {
            await LocalStorage.setHeight(data["object"]["height"].toString());
            setHeight();
            state = state.copyWith(isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> patchAvatar(String? avatar, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"pictureUrl": avatar};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) {
          // no need to return we are saving locally
          state = state.copyWith(isloading: false);
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> sendPhoneNumber(BuildContext context,
      {required SendPhoneNumberRequest request}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _settingsRepositoryInterface
          .changePhoneSendPhoneNumber(request: request);
      response.when(success: (data) {
        // data
        debugPrint(data.toString());
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, "$error $statusCode");
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> sendConfirmationCode(BuildContext context,
      {required SendConfirmationCodeRequest request}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _settingsRepositoryInterface
          .changePhoneSendConfirmationCode(request: request);
      response.when(success: (data) {
        LocalStorage.setPhoneNumber(data["object"]["user"]["login"]);
        LocalStorage.setToken(data["object"]["jwtToken"]);
        debugPrint(data.toString());
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> uploadPicture(BuildContext context,
      {required File image}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response =
          await _settingsRepositoryInterface.addPicture(image: image);
      response.when(success: (data) {
        //
      }, failure: (error, statusCode, operationInfo) {
        //AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        final errorcha = error.toString();
        debugPrint("errorcha $errorcha");
        if (errorcha.contains("Смена фото не чаще 1 раза в неделю")) {
          AppHelpers.showErrorSnack(context,
              "Фото не изменено.Сменить фото можно только один раз в неделью");
          final String whenAccessOpens =
              errorcha.split("неделю/")[1].replaceAll(")", "");
          LocalStorage.setWhenUploadingPhotoOpens(whenAccessOpens);
          if (!state.isNoAccessChangingPhoto) {
            state = state.copyWith(isNoAccessChangingPhoto: true);
          }
          //context.popRoute();
        }
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await uploadPicture(context, image: File(pickedFile.path));
      await getUser(context);
    }
  }

  Future<void> getUser(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      //state = state.copyWith(isloading: true);
      final response = await _settingsRepositoryInterface.getUser();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          if (LocalStorage.getAvatar() != data["object"]["pictureUrl"] &&
              data["object"]["pictureUrl"] != null) {
            state = state.copyWith(avatar: data["object"]["pictureUrl"]);
            LocalStorage.setAvatar(data["object"]["pictureUrl"]);
          }
        }
        //debugPrint(data.toString());
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getAllAvailableSubscribtions(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response =
          await _settingsRepositoryInterface.getAllAvailableSubscribtions();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final listToCollect = <Subscription>[];
            for (var element in listFromServer) {
              final subscription = Subscription.fromJson(element);
              listToCollect.add(subscription);
            }
            state = state.copyWith(allAvailableSubscriptions: listToCollect);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getUserSubscribtions(BuildContext contex) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response =
          await _settingsRepositoryInterface.getUserSubscribtions();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final userSubscription =
                UserSubscription.fromJson(listFromServer[0]);
            state = state.copyWith(
              currentSubscribtion: userSubscription,
              autoRenewal: userSubscription.autoRenewal ?? false,
            );
            if (listFromServer.length > 1) {
              final nextSubscription =
                  UserSubscription.fromJson(listFromServer[1]);
              state = state.copyWith(nextSubscribtion: nextSubscription);
            }
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            contex, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(contex);
    }
  }

  Future<void> purchaseSubscription(BuildContext context, {required int id, required bool autoRenewal}) async{
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _settingsRepositoryInterface.purchaseSubscription(id: id, autoRenewal: autoRenewal);
      response.when(success: (data) async {
        if (data["operationResult"] == "OK") {
          // to get updated subscribtions
          await getUserSubscribtions(context);
          context.popRoute();
          AppHelpers.showSuccessSnack(context, "Подписка успешно оформлена");
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> changeNextSubscription(BuildContext context,
      {required int id}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isChangeSubscribtionLoading: true);
      final response =
          await _settingsRepositoryInterface.changeNextSubscription(id: id);
      response.when(success: (data) async {
        if (data["operationResult"] == "OK") {
          // to get updated subscribtions
          await getUserSubscribtions(context);
          state = state.copyWith(isChangeSubscribtionLoading: false);
          context.popRoute();
        }
      }, failure: (error, statusCode, operationInfo) {
        state = state.copyWith(isChangeSubscribtionLoading: false);
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> toggleAutoRenewal(BuildContext context,
      {required bool val}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(autoRenewal: val);
      final response = await _settingsRepositoryInterface.toggleAutoRenewal(
        val: val,
      );
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          // nothing to do we already update autoRenewal
        }else{
          state = state.copyWith(autoRenewal: !val);
          AppHelpers.showErrorSnack(
            context, "Ошибка при изменении автопродления");
        }
      }, failure: (error, statusCode, operationInfo) {
        state = state.copyWith(autoRenewal: !val);
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  String getEndDateOfCurrentSub() {
    // from 2024-06-03T13:56:25 to 03.06.2024
    final String? endDate = state.currentSubscribtion?.endData;
    if (endDate != null) {
      final List<String> parts = endDate.split("T");
      final List<String> dateParts = parts[0].split("-");
      return "${dateParts[2]}.${dateParts[1]}.${dateParts[0]}";
    } else {
      return "";
    }
  }

  void setQrCodeValue(String value) {
    state = state.copyWith(qrcodeValue: value);
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



  void addCard(String number) {
    state = state.copyWith(cardNumber: number);
  }

  void deleteCard() {
    state = state.copyWith(cardNumber: "");
  }



  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;

    String daysWord = getDayWord(days);
    String hoursWord = getHourWord(hours);

    List<String> parts = [
      if (days > 0) '$days $daysWord',
      if (hours > 0) '$hours $hoursWord',
    ];

    return parts.join(' ');
  }

  String getDayWord(int number) {
    number = number % 100;
    if (number >= 11 && number <= 19) {
      return 'дней';
    } else {
      switch (number % 10) {
        case 1:
          return 'день';
        case 2:
        case 3:
        case 4:
          return 'дня';
        default:
          return 'дней';
      }
    }
  }

  String getHourWord(int number) {
    number = number % 100;
    if (number >= 11 && number <= 19) {
      return 'часов';
    } else {
      switch (number % 10) {
        case 1:
          return 'час';
        case 2:
        case 3:
        case 4:
          return 'часа';
        default:
          return 'часов';
      }
    }
  }

  void setPhone() {
    state = state.copyWith(phoneNumber: LocalStorage.getPhoneNumber());
  }

  void setName() {
    state = state.copyWith(userName: LocalStorage.getUserName());
  }

  void setLastname() {
    state = state.copyWith(userLastName: LocalStorage.getUserLastName());
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

  void setAvatar() {
    state = state.copyWith(avatar: LocalStorage.getAvatar());
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
