// ignore_for_file: use_build_context_synchronously

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/animation_button_effect.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ApplicationSettings extends StatelessWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Настройка приложения",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
       /*  10.verticalSpace,
        eachBlock(
          "assets/svg/notification.svg",
          "Уведомления",
          () {},
        ),
        10.verticalSpace,
        eachBlock(
          "assets/svg/notification.svg",
          "Безопасность",
          () {},
        ),
        10.verticalSpace,
        CustomCard(
          height: 106.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/my_gym.svg",
                    width: 24.w,
                    height: 24.h,
                  ),
                  10.horizontalSpace,
                  CustomText(
                    text: "Хочу добавить своё заведение",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/call_us.svg",
                    width: 24.w,
                    height: 24.h,
                  ),
                  10.horizontalSpace,
                  CustomText(
                    text: "Связь с разработчиками",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        ), */
        10.verticalSpace,
        eachBlock(
          "assets/svg/call_us.svg",
          "Связь с разработчиками",
          () {},
        ),
        10.verticalSpace,
        eachBlock(
          "assets/svg/leave.svg",
          "Выйти из аккаунта",
          () {
            // show dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
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
                          text: "Выход из аккаута",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        16.verticalSpace,
                        CustomCard(
                          child: CustomText(
                            text: "Вы уверены, что хотите выйти из аккаунта?",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                                child: CustomButton(
                              height: 40.h,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              buttonColor: Colors.white,
                              onPressed: () {
                                context.router.pop();
                              },
                              text: "Назад",
                            )),
                            16.horizontalSpace,
                            Expanded(
                              child: CustomButton(
                                height: 40.h,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.white,
                                buttonColor: AppColors.blueColor,
                                onPressed: () async {
                                  await LocalStorage.instance.logOut();
                                  // remove all routes and replace with splash route
                                  context.router
                                      .replaceAll([const SplashRoute()]);
                                },
                                text: "Выйти",
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                  /*  */
                );
              },
            );
          },
        ),
        40.verticalSpace,
      ],
    );
  }
}

Widget eachBlock(String svgPath, String title, void Function()? onTap) {
  return AnimationButtonEffect(
    child: GestureDetector(
      onTap: onTap,
      child: CustomCard(
        bottomPadding: 8.h,
        topPadding: 8.h,
        height: 56.h,
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              //width: 24.w,
              //height: 24.h,
            ),
            10.horizontalSpace,
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    ),
  );
}
