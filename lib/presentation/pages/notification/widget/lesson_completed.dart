import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/notification/notification_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/pages/schedule/widget/rate_dialog.dart';
import 'package:myfit/presentation/pages/schedule/widget/rate_history_modal.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class LessonCompleted extends StatelessWidget {
  final String lessonType;
  final bool unread;
  final String time;
  final String gymName;
  final int gymId;
  final int grade;
  final String lessonDescription;
  final String comment;
  final int gradeId;
  final Widget batteryIcon;
  const LessonCompleted(
      {super.key,
      required this.lessonType,
      required this.unread,
      required this.time,
      required this.gymName,
      required this.grade,
      required this.lessonDescription,
      required this.comment,
      required this.gradeId,
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
                        AppHelpers.getIconSvg(lessonType),
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
            text: "Активность завершилась, хотите оставить отзыв или записаться на неё снова?",
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    if (grade == 0) {
                      //  show dialog to make a rate
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r)),
                              elevation: 0,
                              insetPadding:EdgeInsets.symmetric(horizontal: 16.w),
                              child: Consumer(builder: (context, ref, child) {
                                return RateDialog(
                                    id: gradeId,
                                    gymName: gymName,
                                    describtion: lessonDescription,
                                    afterMakingRate: () {
                                      ref.read(notificationProvider.notifier).getAllNotifications();
                                    },
                                  );
                              },),
                            );
                          });
                    } else {
                      // open dialog to see how we rated before
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 0,
                              insetPadding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                              child: RateHistoryDialog(
                                id: gradeId,
                                gymName: gymName,
                                describtion: lessonDescription,
                                comment: comment,
                                rate: grade,
                              ),
                            );
                          });
                    }
                  },
                  text: grade == 0 ? "Оставить отзыв" : "Cмотреть отзыв",
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 40.h,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  return CustomButton(
                      onPressed: () {
                        ref.read(mapProvider.notifier).setSelectedActivityFromMap(lessonType);
                        context.router.push(ActivityRoute(gymId: gymId));
                      },
                      text: "Записаться ещё",
                      buttonColor: AppColors.blueColor,
                      textColor: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 40.h,
                    );
                },),
              ),
            ],
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
