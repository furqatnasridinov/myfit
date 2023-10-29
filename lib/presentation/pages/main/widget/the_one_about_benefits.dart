import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TheOneAboutBenefits extends StatelessWidget {
  TheOneAboutBenefits({super.key});
  int activeStepState = 1;
  int dotCount = 3;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(left: 10.w, bottom: 10.0.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'О преимущества',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        UiCard(
          cardValue: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 120.w,
                    child: CustomText(
                      text: '«Одно кольцо, чтобы править всеми!»',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: activeStepState.toString(),
                              style: GoogleFonts.raleway(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: '/3',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        children: <Widget>[
                          //UiHorizontalStepper(),
                          StepProgressIndicator(
                              totalSteps: dotCount,
                              currentStep: activeStepState,
                              size: 3.0,
                              customStep: (index, color, _) =>
                                  index < activeStepState
                                      ? Container(
                                          color: const Color.fromRGBO(
                                              119, 170, 249, 1),
                                        )
                                      : Container(
                                          width: 10.0,
                                          color: const Color.fromRGBO(
                                              220, 220, 220, 1),
                                        )),
                        ],
                      )
                    ],
                  )
                ],
              ),
              16.horizontalSpace,
              Flexible(
                child: InterText(
                  text:
                      'Пользуясь нашей подпиской, вы сможете посещать разные активности, без нужды приобретать отдельный абонемент в каждом месте.',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
