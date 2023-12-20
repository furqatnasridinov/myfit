// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:activity/application/registration/registration_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class Registration2Screen extends ConsumerStatefulWidget {
  const Registration2Screen({
    super.key,
  });

  @override
  ConsumerState<Registration2Screen> createState() =>
      _Registration2ScreenState();
}

class _Registration2ScreenState extends ConsumerState<Registration2Screen> {
  TextEditingController controller = TextEditingController();

  final String predefinedCode = '1234';
  bool isCodeError = false;
  bool isPinCodeValidate = false;
  bool isChecking = false;
  Future<void> checkValidation(String code, String userCode) async {
    if (isCodeError) {
      setState(() {
        isCodeError = false;
      });
    }
    isChecking = true;
    await Future.delayed(
      const Duration(milliseconds: 2300),
    );
    isChecking = false;
    if (code == userCode) {
      isPinCodeValidate = true;
      ref.read(registrationProvider.notifier).sendCodeConfirmation(
            LocalStorage.getPhoneNumber(),
            code,
            context,
          );
      setState(() {});
    } else {
      isCodeError = true;
      setState(() {});
    }
  }

  Timer? _timer;
  int counterDown = 59;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (counterDown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            counterDown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(registrationProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // pop button
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  context.router.pop();
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.greyBorder,
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5.w),
                  margin: EdgeInsets.only(left: 16.w, top: 7.h),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 15.r,
                  ),
                ),
              ),
            ),
            // main body

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                      child: CustomText(
                        text:
                            "Дождитесь смс на свой телефон и введите код из сообщения в поле ниже:",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    32.verticalSpace,
                    Center(
                      child: Pinput(
                        autofocus: true,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        onTapOutside: (onTapOutside) {
                          FocusScope.of(context).unfocus();
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        closeKeyboardWhenCompleted: true,
                        controller: controller,
                        onChanged: (value) {
                          controller.text = value;
                          setState(() {});
                        },
                        onCompleted: (onCompleted) {
                          checkValidation(
                            predefinedCode,
                            controller.text,
                          );
                        },
                        defaultPinTheme: event.getDefaultPinTheme(),
                        focusedPinTheme: event.getDefaultPinTheme(),
                        disabledPinTheme: event.getDefaultPinTheme(),
                        submittedPinTheme: isCodeError
                            ? event.getErrorPinTheme()
                            : event.getSubmittedPinTheme(),
                      ),
                    ),

                    //
                    if (isCodeError)
                      Padding(
                        padding: EdgeInsets.only(top: 32.w),
                        child: CustomCard(
                          width: double.maxFinite,
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: "Неверный код, попробуйте ещё раз",
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),

                    //
                    if (isChecking)
                      Padding(
                        padding: EdgeInsets.only(top: 32.w),
                        child: CustomCard(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              // progress
                              SizedBox(
                                width: 22.w,
                                height: 22.h,
                                child: const CircularProgressIndicator(),
                              ),
                              10.verticalSpace,
                              CustomText(
                                textAlign: TextAlign.center,
                                text: "Проверяем код, подождите",
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ],
                          ),
                        ),
                      ),

                    //
                    if (isPinCodeValidate)
                      Padding(
                        padding: EdgeInsets.only(top: 32.w),
                        child: CustomCard(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              // progress
                              SizedBox(
                                width: 22.w,
                                height: 22.h,
                                child: Icon(
                                  Icons.done,
                                  color: AppColors.blueColor,
                                  size: 25.r,
                                ),
                              ),
                              10.verticalSpace,
                              CustomText(
                                textAlign: TextAlign.center,
                                text: "Готово!",
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    32.verticalSpace,
                    InterText(
                      text: "Не пришла смс в течении 1 минуты? ",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    5.verticalSpace,
                    InkWell(
                      onTap: () {
                        if (counterDown == 0) {
                          setState(() {
                            counterDown = 59;
                          });
                          startTimer();
                        }
                      },
                      child: InterText(
                        text: counterDown == 0
                            ? "Отправить снова"
                            : "Отправить ещё раз через $counterDown с",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // waves

            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: SvgPicture.asset(
                  "assets/svg/Vector 13.svg",
                  width: width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
