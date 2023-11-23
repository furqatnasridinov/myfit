import 'dart:async';

import 'package:activity/application/registration/registration_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(const RegistrationState());

  PinTheme getDefaultPinTheme() {
    return PinTheme(
      width: 40.w,
      height: 40.h,
      textStyle: GoogleFonts.raleway(
        fontSize: 20.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
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

  Future<void> checkValidation(String code, String userCode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (code == userCode) {
      state = state.copyWith(isPinCodeValidate: true);
    } else {
      state = state.copyWith(isCodeError: true);
    }
  }

}
