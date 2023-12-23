import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
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
        10.verticalSpace,
        CustomCard(
          bottomPadding: 8.h,
          topPadding: 8.h,
          height: 56.h,
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/svg/notification.svg",
                width: 24.w,
                height: 24.h,
              ),
              10.horizontalSpace,
              CustomText(
                text: "Уведомления",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
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
        ),
        40.verticalSpace,
      ],
    );
  }
}
