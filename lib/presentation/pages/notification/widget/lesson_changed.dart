import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class LessonChanged extends StatelessWidget {
  final String lessonType;
  final bool unread;
  final String time;
  final String gymName;
  final int gymId;
  final DateTime lessonStartDate;
  final Widget batteryIcon;
  final Map<String, dynamic> updates;
  const LessonChanged(
      {super.key,
      required this.lessonType,
      required this.unread,
      required this.time,
      required this.gymName,
      required this.gymId,
      required this.lessonStartDate,
      required this.batteryIcon,
      required this.updates});

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
              if (unread)
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
            text: "Отмена занятия.",
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
          16.verticalSpace,
          CustomText(
            text: AppConstants.lessonChangedLongText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          CustomText(
            text: "Что изменилось:",
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
          5.verticalSpace,
          getNewUpdates(updates, lessonStartDate),
          16.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              return CustomButton(
                onPressed: () {
                  ref.read(activityProvider.notifier)
                  ..setDayOfSelectedLessonFromSearch(AppHelpers.getStringFromDateTime(lessonStartDate))
                  ..setIsFromSearch(true);
                  ref.read(mapProvider.notifier).setSelectedActivityFromMap(lessonType);
                  context.router.push(ActivityRoute(gymId: gymId));
                },
                text: "Записаться",
                buttonColor: Colors.white,
                textColor: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 40.h,
              );
            },
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
                  batteryIcon,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getNewUpdates(Map<String, dynamic> updates, DateTime lessonStartDate) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      if (updates["descriptionOld"] != null)
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Новое описание занятия: ",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              5.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.greyBorder,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(16.r),
                    child: CustomText(
                      text: updates["descriptionNew"],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      if (updates["lessonTimeOld"] != null || updates["durationOld"] != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Дата или время:",
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            5.verticalSpace,
            // shows only when when lessonStart changes
            if(updates["lessonTimeOld"] != null)
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Center(
                        child: CustomText(
                          text: AppHelpers.getChangedLessonStartsAt(
                            DateTime.parse(updates["lessonTimeOld"].toString().replaceAll("T", " "))),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                  ),
                ),
                5.horizontalSpace,
                SvgPicture.asset(
                  "assets/svg/nextNext.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                5.horizontalSpace,
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primaryFadedBorder,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Center(
                        child: CustomText(
                          text: AppHelpers.getChangedLessonStartsAt(
                            DateTime.parse(updates["lessonTimeNew"].toString().replaceAll("T", " "))),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // shows only when when duration(end time) changes
            if(updates["durationOld"] != null)
            Padding(
              padding: EdgeInsets.only(top: updates["lessonTimeOld"] != null ? 16.h : 0),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyBorder,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Center(
                          child: CustomText(
                            text: AppHelpers.getChangedLessonEndsAt(
                                startTime: updates["lessonTimeOld"] == null ? lessonStartDate  :  DateTime.parse(
                                  updates["lessonTimeOld"].toString().replaceAll("T", " ")),
                                durationInString: updates["durationOld"]),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                            color: AppColors.greyText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  SvgPicture.asset(
                    "assets/svg/nextNext.svg",
                    width: 24.w,
                    height: 24.h,
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryFadedBorder,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Center(
                          child: CustomText(
                            text: AppHelpers.getChangedLessonEndsAt(
                                startTime: updates["lessonTimeNew"] == null ? lessonStartDate : DateTime.parse(
                                  updates["lessonTimeNew"].toString().replaceAll("T", " ")),
                                durationInString: updates["durationNew"]),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    ],
  );
}
