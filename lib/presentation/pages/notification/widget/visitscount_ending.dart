import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';

class VisitsCountEnding extends StatelessWidget {
  final String lessonType;
  final bool unread;
  final String title;
  final String description;
  final String time;
  final String gymName;
  final int gymId;
  final Widget batteryIcon;
  const VisitsCountEnding(
      {super.key,
      required this.lessonType,
      required this.unread,
      required this.title,
      required this.description,
      required this.time,
      required this.gymName,
      required this.gymId,
      required this.batteryIcon});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      marginBottom: 16.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: ColoredBox(
                    color: AppColors.backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.all(3.r),
                      child: SvgPicture.asset(
                        AppHelpers().getIconSvg(lessonType),
                      ),
                    ),
                  ),
                ),
              ),
              6.horizontalSpace,
              InterText(
                text: lessonType,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.blueText,
              ),
              const Spacer(),
              if(unread)
              Row(
                children: [
                  SizedBox(
                    width: 6.w,
                    height: 6.h,
                    child: const DecoratedBox(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blueText,
                    )),
                  ),
                  5.horizontalSpace,
                  InterText(
                    text: "Новое",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueText,
                  ),
                ],
              ),
            ],
          ),
          16.verticalSpace,
          CustomText(
            text: title,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          CustomText(
            text: description,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
          16.verticalSpace,
          CustomText(
            text: AppConstants.visitsCountIsEndingLongText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          CustomButton(
            onPressed: () {},
            text: "Подробнее о заведении",
            buttonColor: Colors.white,
            textColor: Colors.black,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 40.h,
          ),
          12.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                "assets/svg/clock.svg",
                width: 16.w,
                height: 16.h,
              ),
              6.horizontalSpace,
              InterText(
                text: time,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText,
              ),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/location.svg",
                    width: 16.w,
                    height: 16.h,
                  ),
                  2.horizontalSpace,
                  InterText(
                    text: gymName,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyText,
                  ),
                  6.horizontalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final bool showBattery = ref.watch(settingsProvider).currentSubscribtion != null;
                      if (showBattery) {
                        return batteryIcon;
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
