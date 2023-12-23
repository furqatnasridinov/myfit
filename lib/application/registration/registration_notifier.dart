import 'dart:ui';

import 'package:activity/application/registration/registration_state.dart';
import 'package:activity/domain/interface/register.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_validator.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
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
      final response =
          await _registerRepositoryInterface.sendPhoneNumber(phoneNumber);
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            // save phone number to local storage
            LocalStorage.setPhoneNumber(phoneNumber)
                .then((value) => context.router.push(
                      const Registration2Route(),
                    ));
          }
        },
        failure: (error, statusCode) {
          AppHelpers.showSnack(
              context, "${error.toString()} ${"statuscode $statusCode"}");
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> sendCodeConfirmation(
      String phoneNumber, String code, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _registerRepositoryInterface.codeConfirmation(
          phoneNumber, code);
      response.when(
        success: (data) {
          if (data.operationResult == "OK") {
            LocalStorage.setUserId(
              data.authResponseBody?.user?.id.toString() ?? "0",
            )
                .then((value) => LocalStorage.setToken(
                    data.authResponseBody?.jwtToken ?? ""))
                .then((value) => moveClientToThirdPage(context));
          }
        },
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> moveClientToThirdPage(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1500)).then(
      (value) => context.replaceRoute(
        const Registration3Route(),
      ),
    );
  }

  
  void enableFormNotValidated(){
    state = state.copyWith(isFormNotValidated: true);
  }

  void formValidated(){
    state = state.copyWith(isFormNotValidated: false);
  }
}
