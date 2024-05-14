// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:myfit/application/schedule/schedule_notifier.dart';
import 'package:myfit/application/schedule/schedule_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:myfit/presentation/pages/schedule/widget/rate_dialog.dart';
import 'package:myfit/presentation/pages/schedule/widget/widget.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CompletedSchedules extends ConsumerWidget {
  const CompletedSchedules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(scheduleProvider.notifier);
    final completedSchedules = ref.watch(scheduleProvider).completedSchedules;
    final completedSchedulesShown = ref.watch(scheduleProvider).completedSchedulesShown;
    final completedLessonListAnimaion = ref.watch(scheduleProvider).completedLessonListAnimaion;
    return completedSchedules.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Column(
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Прошедшие занятия",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (completedSchedulesShown) {
                          event.hideCompletedSchedules();
                          if (completedLessonListAnimaion) {
                            event.setAnimationCompletedLessons(false);
                          }
                        } else {
                          event.showCompletedSchedules();
                          if (!completedLessonListAnimaion) {
                            event.setAnimationCompletedLessons(true);
                          }
                        }
                      },
                      child: AnimationButtonEffect(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.blueBorder,
                            ),
                          ),
                          child: SizedBox(
                            height: 40.h,
                            width: 135.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    //width: 95.w,
                                    child: CustomText(
                                      text: completedSchedulesShown
                                          ? "Свернуть"
                                          : "Развернуть",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 300),
                                    tween: Tween(
                                        begin: 0,
                                        end: completedSchedulesShown ? 1.0 : 0),
                                    builder: (BuildContext context,
                                        double angle, Widget? child) {
                                      return Transform.rotate(
                                        angle: angle * pi,
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20.sp,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,

                // body
                //if (completedSchedulesShown)
                Consumer(builder: (context, watch, child) {
                  final completedSchedules =
                      ref.watch(scheduleProvider).completedSchedules;
                  
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      height: completedSchedulesShown ? (null) : 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedSchedules.length,
                        itemBuilder: (context, index) {
                          return listOfActivitiesEachItem(
                            context,
                            completedLessonListAnimaion,
                            index,
                            completedSchedules[index].id,
                            completedSchedules[index].time,
                            completedSchedules[index].describtion,
                            completedSchedules[index].gymName,
                            completedSchedules[index].grade,
                            completedSchedules[index].gymId,
                            completedSchedules[index].comment,
                            event,
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
  }
}

Widget listOfActivitiesEachItem(
  BuildContext context,
  final bool animationStart,
  final int index,
  final int id,
  final String time,
  final String description,
  final String name,
  final int grade,
  final int gymId,
  final String comment,
  final ScheduleNotifier event,
) {
  return AnimatedContainer(
    curve: Curves.easeInOut,
    duration: animationStart
        ? Duration(milliseconds: 350 + (index * 150))
        : Duration(milliseconds: 650 - (index * 150)),
    //height: 110.h,
    transform: animationStart
        ? Matrix4.translationValues(0, 0, 0)
        : Matrix4.translationValues(400, 0, 0),
    //color: Colors.purple,
    margin: EdgeInsets.only(bottom: 5.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (grade == 0) {
                  //  show dialog to make a rate
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: RateDialog(
                            id: id,
                            gymName: name,
                            describtion: description,
                          ),
                        );
                      });
                }
                /* else {
                  // delete rate
                  await event.deleteRate(context, id: id);
                  event.getCompletedSchedules(context);
                } */
              },
              child: SvgPicture.asset(
                grade == 0
                    ? "assets/svg/star_outlined.svg"
                    : "assets/svg/star_filled.svg",
              ),
            ),
            if (grade != 0)
              InterText(
                text: grade.toString(),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),

        // custom card datas about schedules
        AnimationButtonEffect(
          disabled: grade == 0,
          child: GestureDetector(
            onTap: () {
              if (grade != 0) {
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
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: RateHistoryDialog(
                          id: id,
                          gymName: name,
                          describtion: description,
                          comment: comment,
                          rate: grade,
                        ),
                      );
                    });
              }
            },
            child: CustomCard(
              //color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top part
                  SizedBox(
                    //color: Colors.blue,
                    width: 265.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // describtion
                        SizedBox(
                          width: 220.w,
                          child: CustomText(
                            //text: AppConstants.confirmationText,
                            text: description,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.horizontalSpace,
                        // three dots
                        dropDownCompleted(
                          // onRateClicked
                          () {
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
                                    child: RateDialog(
                                        id: id,
                                        gymName: name,
                                        describtion: description),
                                  );
                                });
                          },
                          // onNavigate
                          () async {
                            context.router.push(ActivityRoute(gymId: gymId));
                          },
                          grade == 0,
                        ),
                      ],
                    ),
                  ),
                  14.verticalSpace,
                  // bottom part
                  SizedBox(
                    //color: Colors.green,
                    width: 265.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          //color: Colors.red,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svg/clock.svg"),
                              4.horizontalSpace,
                              InterText(
                                text: time,
                                color: AppColors.greyText,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        5.horizontalSpace,
                        // location
                        Flexible(
                          child: SizedBox(
                            //width: 200.w,
                            //color: Colors.red,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset("assets/svg/location.svg"),
                                4.horizontalSpace,
                                Flexible(
                                  child: SizedBox(
                                    //width: 160.w,
                                    //color: Colors.green,
                                    child: InterText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      //text: AppConstants.confirmationText,
                                      text: name,
                                      color: AppColors.greyText,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget dropDownCompleted(
  void Function()? onRateClicked,
  void Function()? onNavigate,
  bool showRate,
) {
  return UiDropDownMenu(
    maxWidth: 250.w,
    customOffset: [-25.0.w, -25.h],
    dropDownItemsList: showRate
        ? [
            {
              'title': 'Оставить отзыв',
              'icon': SvgPicture.asset(
                'assets/svg/edit_icon.svg',
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': onRateClicked,
            },
            {
              'title': 'Открыть расписание заведения',
              'icon': SvgPicture.asset(
                'assets/svg/calendar.svg',
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': onNavigate
            },
          ]
        : [
            {
              'title': 'Открыть расписание заведения',
              'icon': SvgPicture.asset(
                'assets/svg/calendar.svg',
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': onNavigate
            },
          ],

    dropDownChild: const Icon(
      Icons.more_vert,
      color: Colors.black,
    ),
    //
  );
}
