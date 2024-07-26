// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:myfit/application/registration/registration_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/register.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_validator.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier(this._registerRepositoryInterface)
      : super(const RegistrationState());
  final RegisterRepositoryInterface _registerRepositoryInterface;

  PinTheme getDefaultPinTheme() {
    return PinTheme(
      width: 40.w,
      height: 40.h,
      textStyle: GoogleFonts.raleway(
        fontSize: 20.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.liningFigures()],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.greyBorder,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  PinTheme getErrorPinTheme() {
    return PinTheme(
      width: 40.w,
      height: 40.h,
      textStyle: GoogleFonts.raleway(
        fontSize: 20.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.liningFigures()],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.red,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  PinTheme getSubmittedPinTheme() {
    return PinTheme(
      width: 40.w,
      height: 40.h,
      textStyle: GoogleFonts.raleway(
        fontSize: 20.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.liningFigures()],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.blueColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  void setPhone(String text) {
    state = state.copyWith(phoneNumber: text);
    state = state.copyWith(isValidPhone: AppValidators.isValidPhone(text));
  }

  Future<void> sendPhoneNumber(String phoneNumber, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(sendPhoneNumberLoading: true);
      try {
      } catch (e) {
         AppHelpers.showErrorSnack(context, "Ошибка при получении fcm token ${e.toString()}");
      }
      final response = await _registerRepositoryInterface.sendPhoneNumber(phoneNumber);
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            state = state.copyWith(sendPhoneNumberLoading: false);
            context.router.push(const Registration2Route());
          }else{
            AppHelpers.showErrorSnack(context, "operationResult is not OK (sendPhoneNumber)");
            state = state.copyWith(sendPhoneNumberLoading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(sendPhoneNumberLoading: false);
          AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> sendCodeConfirmation(
      String phoneNumber, String code, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
       String? fcmToken = "";
       fcmToken = Platform.isIOS  ? "" : await FirebaseMessaging.instance.getToken();
      log("fcm token: $fcmToken");
      final response = await _registerRepositoryInterface.codeConfirmation(phoneNumber, code);
      response.when(
        success: (data) async {
          /* PageRouteInfo<dynamic> nextRoute = data.user?.firstName == null 
              ? const Registration3Route()
              : const Main2Route(); */
          PageRouteInfo<dynamic> nextRoute = const Registration3Route(); // remove this
          await LocalStorage.setToken(data.jwtToken ?? "");
          await LocalStorage.setPhoneNumber(phoneNumber);
          await LocalStorage.setUserId(data.user?.id.toString() ?? "0");
          if (data.user?.firstName != null) {
            await Future.wait([
              LocalStorage.setUserName(data.user?.firstName ?? ""),
              LocalStorage.setUserLastName(data.user?.lastName ?? ""),
              LocalStorage.setUserPatronomic(data.user?.patronymic ?? ""),
              //LocalStorage.setPhoneNumber(data.user?.login ?? ""),
              LocalStorage.setUserBirthday(data.user?.birthdayDate ?? ""),
              LocalStorage.setSelectedCity(data.user?.city?.name ?? ""),
              LocalStorage.setSelectedCityLat(data.user?.city?.latitude ?? ""),
              LocalStorage.setSelectedCityLon(data.user?.city?.longitude ?? ""),
              LocalStorage.setAge(data.user?.age.toString() ?? ""),
              LocalStorage.setAvatar(data.user?.backgroundPictureUrl ?? ""),
              LocalStorage.setHeight(data.user?.height.toString() ?? ""),
              LocalStorage.setGender(data.user?.gender ?? ""),
              LocalStorage.setWeight(data.user?.weight.toString() ?? ""),
            ]);
          }
          // save login time locally
          final String dateTimeToString = DateTime.now().toString();
          LocalStorage.setLoginTime(dateTimeToString);
          await updateFcmToken(context, token: fcmToken ?? "");
          moveClientToNextPage(context, nextRoute);
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> updateFcmToken(BuildContext context,{required String token}) async {
    final response = await _registerRepositoryInterface.updateFcmToken(token: token);
    response.when(
      success: (data) {
        log("fcm token updated");
      },
      failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, error.toString());
      },
    );
  }

  Future<void> moveClientToNextPage(
      BuildContext context, PageRouteInfo<dynamic> nextRoute) async {
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (nextRoute.routeName == "Main2Route") {
        context.router.replaceAll([nextRoute]);
      } else {
        context.replaceRoute(nextRoute);
      }
    });
  }

  void enableFormNotValidated() {
    state = state.copyWith(isFormNotValidated: true);
  }

  void formValidated() {
    state = state.copyWith(isFormNotValidated: false);
  }
}
