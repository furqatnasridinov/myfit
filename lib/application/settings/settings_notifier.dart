// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:myfit/application/settings/settings_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/settings.dart';
import 'package:myfit/infrastructure/models/data/promocode.dart';
import 'package:myfit/infrastructure/models/data/referal.dart';
import 'package:myfit/infrastructure/models/data/user_instance.dart';
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
      : super( SettingsState(promocodeController: TextEditingController()));
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
    setBirthday();
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

  void openDropDown() {
    state = state.copyWith(dropDownOpened: true);
  }

  void closeDropDown() {
    state = state.copyWith(dropDownOpened: false);
  }

  void openGenderDropDown() {
    state = state.copyWith(genderDropDownOpened: true);
  }

  void closeGenderDropDown() {
    state = state.copyWith(genderDropDownOpened: false);
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
          AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
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
      final code = gender == "Мужчина" ? 0 : 1;
      final request = {"gender": code};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) async{
          if (data["operationResult"] == "OK") {
            await LocalStorage.setGender(data["object"]["gender"].toString());
            setGender();
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

  Future<void> patchBirthday(String? birthday, BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = {"birthdayDate": birthday};
      final response = await _settingsRepositoryInterface.patchUser(
        request: request,
      );
      response.when(
        success: (data) async{
          if (data["operationResult"] == "OK") {
            await LocalStorage.setUserBirthday(data["object"]["birthdayDate"].toString());
            final int age = AppHelpers.getYearFromBirthday(birthday ?? "");
            await LocalStorage.setAge(age.toString());
            state = state.copyWith(age: age.toString());
            setBirthday();
          }
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
      state = state.copyWith(isPhotoUploading: true);
      final response = await _settingsRepositoryInterface.addPicture(image: image);
      response.when(success: (data) {
        state = state.copyWith(isPhotoUploading: false);
      }, failure: (error, statusCode, operationInfo) {
        //AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        final errorcha = error.toString();
         state = state.copyWith(isPhotoUploading: false);
        debugPrint("errorcha $errorcha");
        if (errorcha.contains("Смена фото не чаще 1 раза в неделю")) {
          AppHelpers.showErrorSnack(context, "Фото не изменено.Сменить фото можно только один раз в неделю");
          final String whenAccessOpens = errorcha.split("неделю/")[1].replaceAll(")", "");
          LocalStorage.setWhenUploadingPhotoOpens(whenAccessOpens);
          if (!state.isNoAccessChangingPhoto) {
            state = state.copyWith(isNoAccessChangingPhoto: true);
          }
        }
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> pickImageFromGallery(BuildContext context, {bool sendRuest = false }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // save image to local storage to show like preview
      state = state.copyWith(avatarTmp: pickedFile.path);
      if (sendRuest) {
        await uploadPicture(context, image: File(pickedFile.path));
        await getUser(context);
      }
    }
  }

  void clearAvatarTmp() {
    state = state.copyWith(avatarTmp: "");
  }

  Future<void> getUser(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      //state = state.copyWith(isloading: true);
      final response = await _settingsRepositoryInterface.getUser();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final user = UserInstance.fromJson(data["object"]);
          getMissingInfos(user);
          state = state.copyWith(user: user);
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

  void getMissingInfos(UserInstance user){
    final List<String> listToCollectInfos = [];
    if (user.firstName == null && !listToCollectInfos.contains("firstName")) {
      listToCollectInfos.add("firstName");
    }
    if (user.lastName == null && !listToCollectInfos.contains("lastName")) {
      listToCollectInfos.add("lastName");
    }
    if (user.gender == null && !listToCollectInfos.contains("gender")) {
      listToCollectInfos.add("gender");
    }
    if (user.birthdayDate == null && !listToCollectInfos.contains("birthdayDate")) {
      listToCollectInfos.add("birthdayDate");
    }
   /*  if ((user.age == null || user.age == 0) && !listToCollectInfos.contains("age")) {
      listToCollectInfos.add("age");
    }
    if ((user.height == null || user.height == 0) && !listToCollectInfos.contains("height")) {
      listToCollectInfos.add("height");
    }
    if ((user.weight == null || user.weight == 0) && !listToCollectInfos.contains("weight")) {
      listToCollectInfos.add("weight");
    } */
    if (user.city == null && !listToCollectInfos.contains("city")) {
      listToCollectInfos.add("city");
    }
    state = state.copyWith(missingInfo: listToCollectInfos);
  }

  Future<void> getAllAvailableSubscribtions(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(allSubsLoading: true);
      final response = await _settingsRepositoryInterface.getAllAvailableSubscribtions();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final List<dynamic> subscriptionsList = data["object"]["subscriptions"];
          //final reflink = data["object"]["reflink"];
          if (subscriptionsList.isNotEmpty) {
            final listToCollect = <Subscription>[];
            for (var element in subscriptionsList) {
              final subscription = Subscription.fromJson(element);
              if (subscription.price == 0) {
                //final int  allBonusesOfUser = state.referalInfo?.bonus ?? 0;
                final int recievedBonuses = state.referalInfo?.receivedBonus ?? 0;
                final int usedBonus = state.referalInfo?.usedBonus ?? 0;
                final int bonusesAvailable = recievedBonuses - usedBonus;
                if (bonusesAvailable > 0 || state.currentSubscribtion?.subscription?.id == subscription.id) {
                  listToCollect.add(subscription);
                  state = state.copyWith(bonusSubsLength: bonusesAvailable);
                }
              }else{
                listToCollect.add(subscription);
              }
            }
            state = state.copyWith(allAvailableSubscriptions: listToCollect);
          }
          state = state.copyWith(allSubsLoading: false);
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        state = state.copyWith(allSubsLoading: false);
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getUserSubscribtions(BuildContext contex) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _settingsRepositoryInterface.getUserSubscribtions();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"]["userSubscriptions"] as List;
          final bool autoRenewal = data["object"]["autoRenewal"] ?? false;
          setAutoRenewal(autoRenewal);
          if (listFromServer.isNotEmpty) {
            // первый json как currentSubscribtion
            final currentSub = UserSubscription(
              subscription:Subscription.fromJson(listFromServer[0]["subscription"]),
              autoRenewal: listFromServer[0]["autoRenewal"],
              firstBuyData: listFromServer[0]["firstBuyData"],
              endData: listFromServer[0]["endData"], //"2024-07-04T11:43:58",
              prolongationData: listFromServer[0]["prolongationData"],
              endDataFormatted: getWhenCurrentSubEnds(listFromServer[0]["updateData"]),
            );
            state = state.copyWith(currentSubscribtion: currentSub);
            // второй json как nextSubscribtion
            if (listFromServer.length > 1) {
              final nextSubscription = UserSubscription(
                subscription:Subscription.fromJson(listFromServer[1]["subscription"]),
                autoRenewal: listFromServer[1]["autoRenewal"],
                firstBuyData: listFromServer[1]["firstBuyData"],
                endData: listFromServer[1]["endData"],
                prolongationData: listFromServer[1]["prolongationData"],
                endDataFormatted: "",
              );
              state = state.copyWith(nextSubscribtion: nextSubscription);
            }
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(contex, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(contex);
    }
  }

  void setAutoRenewal(bool val) {
    state = state.copyWith(autoRenewal: val);
  }

  Future<void> purchaseSubscription(BuildContext context,
      {required int id, required bool autoRenewal}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isChangeSubscribtionLoading: true);
      final response = await _settingsRepositoryInterface.purchaseSubscription(
          id: id, autoRenewal: autoRenewal);
      response.when(success: (data) async {
        if (data["operationResult"] == "OK") {
          // to get updated subscribtions and promocodes(if they were used)
          getPromocodesQueue(context);
          getAllAvailableSubscribtions(context);
          await getUserSubscribtions(context);
          context.popRoute();
          AppHelpers.showSuccessSnack(context, "Подписка успешно оформлена");
          state = state.copyWith(isChangeSubscribtionLoading: false);
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        state = state.copyWith(isChangeSubscribtionLoading: false);
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
        } else {
          state = state.copyWith(autoRenewal: !val);
          AppHelpers.showErrorSnack(context, "Ошибка при изменении автопродления");
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


  Future<void> applyPromocede(BuildContext context, {required String code, bool autoRefresh = true}) async{
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isPromocodeLoading: true);
      final response = await _settingsRepositoryInterface.applyPromocode(code: code);
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          if (state.isPromocodeError) {
            state = state.copyWith(
              isPromocodeError: false,
              promocodeErrorMessage: "",
            );
          }
          try {
            final String successMessage = data["object"].toString().split("/")[1];
            state = state.copyWith(newPromocodeDescription: successMessage);
          } catch (e) {
            debugPrint("error $e");
          }
          state = state.copyWith(
            isPromocodeSuccess: true,
            isPromocodeLoading: false);
            getAllAvailableSubscribtions(context);
            getPromocodesQueue(context);
            //getPromocodes(context);
            if (autoRefresh) {
              refreshDataAfterPromocodeSubmitted();
            }
        }
      }, failure: (error, statusCode, operationInfo) {
        if (statusCode == 500) {
          final String errorCha = NetworkExceptions.getErrorMessage(error);
          final String errorMesaaage = errorCha.split("Internal Server Error,")[1];
          state = state.copyWith(promocodeErrorMessage: errorMesaaage);
        } else{
          AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        }
         state = state.copyWith(
          isPromocodeLoading: false,
          isPromocodeError: true,
        );
        if (autoRefresh) {
          refreshDataAfterPromocodeSubmitted();
        }
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getPromocodes(BuildContext context) async{
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _settingsRepositoryInterface.getPromocodes();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final listToCollect = <Promocode>[];
            for (var element in listFromServer) {
              final promocode = Promocode.fromJson(element);
              listToCollect.add(promocode);
            }
           state = state.copyWith(promocodesHistory: listToCollect);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getPromocodesQueue(BuildContext context) async{
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _settingsRepositoryInterface.getPromocodesQueue();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final listFromServer = data["object"] as List;
          if (listFromServer.isNotEmpty) {
            final listToCollect = <Promocode>[];
            for (var element in listFromServer) {
              final promocode = Promocode.fromJson(element);
              listToCollect.add(promocode);
            }
           state = state.copyWith(promocodesQueue: listToCollect);
          }else{
            state = state.copyWith(promocodesQueue: []);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }


  Future<void> getReferalInfo(BuildContext context) async { 
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _settingsRepositoryInterface.getReferalInfo();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final referalInfo = Referal.fromJson(data["object"]);
          state = state.copyWith(referalInfo: referalInfo);
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getReferalBonus(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(referalInfoLoading: true);
      final response = await _settingsRepositoryInterface.getReferalBonus();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
         final referalInfo = Referal.fromJson(data["object"]);
          state = state.copyWith(referalInfo: referalInfo, referalInfoLoading: false);
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        state = state.copyWith(referalInfoLoading: false);
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

  String getWhenCurrentSubEnds(String futureDateString) {
    // from 2024-06-03T13:56:25 to 2 дня 3 часа
    DateTime now = DateTime.now();
    DateTime futureDate = DateTime.parse(futureDateString);
    if (futureDate.isAfter(now)) {
      Duration difference = futureDate.difference(now);

      if (difference.inDays >= 1) {
        return 'через ${difference.inDays} ${plural(difference.inDays, [
              'день',
              'дня',
              'дней'
            ])}';
      } else if (difference.inHours >= 1) {
        return 'через ${difference.inHours} ${plural(difference.inHours, [
              'час',
              'часа',
              'часов'
            ])}';
      } else {
        return 'через ${difference.inMinutes} ${plural(difference.inMinutes, [
              'минуту',
              'минуты',
              'минут'
            ])}';
      }
    } else {
      return "если это показывается то !futureDate.isAfter(now)";
    }
  }

  String plural(int num, List<String> forms) {
    if (num % 10 == 1 && num % 100 != 11) {
      return forms[0];
    } else if (num % 10 >= 2 &&
        num % 10 <= 4 &&
        (num % 100 < 10 || num % 100 >= 20)) {
      return forms[1];
    } else {
      return forms[2];
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

  void setTakeButtonCliked(bool val){
    state = state.copyWith(takeBonusButtonClicked: val);
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
    if (LocalStorage.getUserBirthday().isNotEmpty) {
      final int age = AppHelpers.getYearFromBirthday(LocalStorage.getUserBirthday());
      state = state.copyWith(age: age.toString());
    }
  }

  void setWeight() {
    state = state.copyWith(weight: LocalStorage.getWeight());
  }

  void setHeight() {
    state = state.copyWith(height: LocalStorage.getHeight());
  }

  void setGender() {
    state = state.copyWith(gender: LocalStorage.getGender());
  }

  void setAvatar() {
    state = state.copyWith(avatar: LocalStorage.getAvatar());
  }

  void setBirthday(){
    state = state.copyWith(birthday: LocalStorage.getUserBirthday());
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

  void setShowPromocodeResponse(bool val) {
    state = state.copyWith(showPromocodeResponseInPromodesSection: val);
  }

  void getReminderDisabledOrEnabled() {
    if (LocalStorage.isReminderDisabled()) {
      state = state.copyWith(isReminderDisabled: true);
    } else {
      state = state.copyWith(isReminderDisabled: false);
    }
  }

  void setPromocodeValue(String value) {
    if (value.isEmpty && state.isPromocodeError) {
      state = state.copyWith(
        isPromocodeError: false,
        promocodeErrorMessage: "",
      );  
    }
    if (value.contains("myfit-russia.ru/inv/") && value.length > 23) {
      value = value.split("inv/")[1];
    }
    state.promocodeController?.text = value;
    state = state.copyWith(promocodeValue: value);
  }



  void cleanLastPromocodeError() {
    if (state.isPromocodeError) {
      state = state.copyWith(
        isPromocodeError: false,
        promocodeErrorMessage: "",
      );
    }
    if (state.isPromocodeSuccess) {
      state = state.copyWith(
        isPromocodeSuccess: false,
        promocodeValue: "",
      );
    }
  }

  Future<void> refreshDataAfterPromocodeSubmitted()async{
    await Future.delayed(const Duration(seconds: 3));
    state.promocodeController?.clear();
    if (state.isPromocodeSuccess) {
      state = state.copyWith(
        isPromocodeSuccess: false,
        promocodeValue: "",
        showPromocodeResponseInPromodesSection: false,
      );
    }
    if (state.isPromocodeError) {
      state = state.copyWith(
        isPromocodeError: false,
        promocodeErrorMessage: "",
        showPromocodeResponseInPromodesSection: false,
      );
    }
  }

  void setIsFromReferalDeepLink(bool val) {
    state = state.copyWith(isFromReferalDeepLink: val);
  }

  void setReferalDeepLinkValue(String value) {
    List<String> parts = value.split("inv/");
    state = state.copyWith(referalDeepLinkValue: parts[1]);
  }
}
