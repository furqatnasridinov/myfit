import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo and Text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/myfit_text.svg",
                    width: 239.w,
                    height: 66.h,
                  ),
                  5.verticalSpace,
                  CustomText(
                    text: "Активная жизнь с одной подпиской",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  32.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomCard(
                      borderColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppConstants.confirmationText,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          1.verticalSpace,
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding:
                                        REdgeInsets.symmetric(horizontal: 16.w),
                                    child: CustomCard(
                                        height: 444.h,
                                        borderColor: Colors.transparent,
                                        width: double.maxFinite,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text:
                                                  "Пользовательское соглашение",
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            16.verticalSpace,
                                            SizedBox(
                                              height: 250.h,
                                              child: SingleChildScrollView(
                                                child: InterText(
                                                  text: AppConstants
                                                      .userAgreement,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            16.verticalSpace,
                                            CustomButton(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              buttonColor: AppColors.blueColor,
                                              textColor: Colors.white,
                                              height: 40.h,
                                              onPressed: () {
                                                context.replaceRoute(Registration1Route());
                                              },
                                              text: "Я согласен, продолжить",
                                            ),
                                            5.verticalSpace,
                                            CustomButton(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              height: 40.h,
                                              onPressed: () {
                                                context.popRoute();
                                              },
                                              text: "Вернуться",
                                            )
                                          ],
                                        )),
                                  );
                                },
                              );
                            },
                            child: CustomText(
                              text: "пользовательское соглашение",
                              color: AppColors.blueText,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                          32.verticalSpace,
                          Container(
                            height: 56.h,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(109, 150, 212, 1),
                                  offset: Offset(0, 15),
                                  blurRadius: 18,
                                  spreadRadius: -15,
                                ),
                              ],
                            ),
                            child: CustomButton(
                              buttonColor: AppColors.blueColor,
                              textColor: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              onPressed: () {
                                context.replaceRoute(Registration1Route());
                              },
                              text: "Продолжить",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
