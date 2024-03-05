// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:activity/application/registration/registration_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import '../../../components/inter_text.dart';

class ChangingPhoneDialog extends StatefulWidget {
  final String newPhoneNumber;
  void Function()? undoAction;
  void Function()? onSuccessfulChange;
  ChangingPhoneDialog({
    Key? key,
    required this.newPhoneNumber,
    this.undoAction,
    this.onSuccessfulChange,
  }) : super(key: key);

  @override
  State<ChangingPhoneDialog> createState() => _ChangingPhoneDialogState();
}

class _ChangingPhoneDialogState extends State<ChangingPhoneDialog> {
  late TextEditingController pinputController;
  bool isCodeError = false;

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
    return Consumer(builder: (context, ref, child) {
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
                  pinputController.text = value;
                  setState(() {});
                },
                onCompleted: (onCompleted) {
                  if (pinputController.text != "1234") {
                    isCodeError = true;
                    setState(() {});
                  } else {
                    widget.onSuccessfulChange!();
                  }
                },
                defaultPinTheme: event.getDefaultPinTheme(),
                focusedPinTheme: event.getDefaultPinTheme(),
                disabledPinTheme: event.getDefaultPinTheme(),
                submittedPinTheme: isCodeError
                    ? event.getErrorPinTheme()
                    : event.getSubmittedPinTheme(),
              ),
              16.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
    });
  }
}
