// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_switch.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
        child: Consumer(builder: (contex, ref, child) {
          final cardNumber = ref.watch(settingsProvider).cardNumber;
          final event = ref.read(settingsProvider.notifier);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Оплата",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              16.verticalSpace,
              CustomCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimationButtonEffect(
                    disabled: cardNumber.isNotEmpty,
                    child: GestureDetector(
                      onTap: () {
                        if (cardNumber.isEmpty) {
                          event.addCard("**** **** **** 1234");
                        }
                      },
                      child: SizedBox(
                        height: 50.h,
                        width: double.maxFinite,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.fadedBlueBorder)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: cardNumber.isEmpty
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 15.r,
                                        color: AppColors.blueColor,
                                      ),
                                      10.horizontalSpace,
                                      CustomText(
                                        text: "Добавить новую карту",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SvgPicture.asset("assets/svg/card_icon.svg"),
                                      10.horizontalSpace,
                                      CustomText(
                                        text: cardNumber,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          //event.deleteCard();
                                        },
                                        child: CustomText(
                                          text: "Удалить карту",
                                          fontSize: 14.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  cardNumber.isEmpty ? 0.verticalSpace : 16.verticalSpace,
                  if (cardNumber.isNotEmpty)
                    Row(
                      children: [
                        Consumer(builder: (contex, ref, child) {
                          final autoRenewal = ref.watch(settingsProvider).autoRenewal;
                          final event = ref.read(settingsProvider.notifier);
                          return CustomSwitch(
                            value: autoRenewal,
                            onChanged: (value) async{
                              event.toggleAutoRenewal(context, val: value);
                              if (value) {
                                await Future.delayed(const Duration(milliseconds: 500));
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        elevation: 0,
                                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                        child: autoRenewalDialog(),
                                      );
                                    },
                                  );
                              }
                            },
                          );
                        }),
                        10.horizontalSpace,
                        CustomText(
                          text: "Автопродление подписки",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    )
                ],
              ),),
            ],
          );
        }));
  }
}

Widget autoRenewalDialog(){
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(settingsProvider.notifier);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Включение автопродления",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            24.verticalSpace,
            CustomText(
              text: AppConstants.autoRenewalLongText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
            10.verticalSpace,
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Списание будет происходить",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: " за 2 дня",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: Colors.black,
                    fontFeatures: const [FontFeature.liningFigures()],
                  ),
                ),
                TextSpan(
                  text: " до начала следующего периода. Следующее списание ",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: Colors.black,
                    fontFeatures: const [FontFeature.liningFigures()],
                  ),
                ),
                TextSpan(
                  text: AppHelpers.getAutoRenewalDay(notifier.getEndDateOfCurrentSub()),
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: Colors.black,
                    fontFeatures: const [FontFeature.liningFigures()],
                  ),
                ),
              ]),
            ),
            10.verticalSpace,
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Мы дополнительно оповестим вас",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: " за 2 дня",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: Colors.black,
                    fontFeatures: const [FontFeature.liningFigures()],
                  ),
                ),
                TextSpan(
                  text: " до списания, чтобы оно не стало неожиданностью.",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: Colors.black,
                  ),
                ),
              ]),
            ),
            24.verticalSpace,
            CustomButton(
              onPressed: () {
                context.router.pop();
              },
              text: "Хорошо, спасибо",
              height: 40.h,
              buttonColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
      },
    ),
  );
}
