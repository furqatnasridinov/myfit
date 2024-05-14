// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously
import 'dart:async';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:myfit/application/registration/registration_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import '../../../components/inter_text.dart';

class ChangingPhoneDialog extends ConsumerStatefulWidget {
  final String newPhoneNumber;
  void Function()? undoAction;
  ChangingPhoneDialog({
    Key? key,
    required this.newPhoneNumber,
    this.undoAction,
  }) : super(key: key);

  @override
  ConsumerState<ChangingPhoneDialog> createState() =>
      _ChangingPhoneDialogState();
}

class _ChangingPhoneDialogState extends ConsumerState<ChangingPhoneDialog> {
  late TextEditingController pinputController;
  final String predefinedCode = '1234';
  bool isCodeError = false;
  bool isChecking = false;
  Timer? _timer;
  int counterDown = 59;

  Future<void> checkValidation(String code, String userCode) async {
    if (isCodeError) {
      isCodeError = false;
      //setState(() {});
    }
    isChecking = true;
    await Future.delayed(
      const Duration(milliseconds: 1300),
    );
    isChecking = false;
    if (code == userCode) {
      ref.read(settingsProvider.notifier).sendConfirmationCode(context,
          request: SendConfirmationCodeRequest(
            confirmToken: userCode,
            login: LocalStorage.getPhoneNumber(),
            newNumber: widget.newPhoneNumber,
          ));
      context.router.pop();
      ref.read(settingsProvider.notifier).closeEditingPhone();
      await Future.delayed(const Duration(milliseconds: 100));
      //"Номер был успешно изменён",
      showSuccessDiaLog(context);
      //setState(() {});
    } else {
      isCodeError = true;
      //setState(() {});
    }
  }

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
  void initState() {
    super.initState();
    pinputController = TextEditingController();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(registrationProvider.notifier);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: SizedBox(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Подтверждение по SMS",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            16.verticalSpace,
            CustomCard(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Дождитесь смс на номер ',
                      style: GoogleFonts.raleway(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: widget.newPhoneNumber,
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.liningFigures()],
                      ),
                    ),
                    TextSpan(
                      text: ' и введите код из сообщения в поле ниже:',
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            Pinput(
              //autofocus: true,
              crossAxisAlignment: CrossAxisAlignment.center,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              onTapOutside: (onTapOutside) {
                FocusScope.of(context).unfocus();
              },
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              closeKeyboardWhenCompleted: true,
              controller: pinputController,
              onChanged: (value) {
                if (value.length < 4 && isCodeError) {
                  isCodeError = false;
                }
                pinputController.text = value;
                //setState(() {});
              },
              onCompleted: (onCompleted) async {
                await checkValidation(predefinedCode, onCompleted);
              },
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              defaultPinTheme: event.getDefaultPinTheme(),
              focusedPinTheme: event.getDefaultPinTheme(),
              disabledPinTheme: event.getDefaultPinTheme(),
              submittedPinTheme: isCodeError
                  ? event.getErrorPinTheme()
                  : event.getSubmittedPinTheme(),
            ),
            //16.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                16.verticalSpace,
                InterText(
                  text: "Не пришла смс в течении 1 минуты? ",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                2.verticalSpace,
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
                ),
              ],
            ),
            16.verticalSpace,
            CustomButton(
              onPressed: widget.undoAction,
              text: "Отменить и вернуться",
              buttonColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 40.h,
            )
          ],
        )),
      ),
    );
  }
}

void showSuccessDiaLog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: AppColors.blueColor,
                      ),
                      5.horizontalSpace,
                      CustomText(
                        text: "Номер был успешно изменён",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                  16.verticalSpace,
                  CustomButton(
                    onPressed: () {
                      context.router.pop();
                    },
                    text: "Спасибо",
                    height: 40.h,
                    width: 110.w,
                    buttonColor: AppColors.blueColor,
                    textColor: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),
          ),
        );
      });
}
