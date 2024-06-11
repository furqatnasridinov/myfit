// ignore_for_file: use_build_context_synchronously
import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TheOneWithCalendar extends StatelessWidget {
  final ActivityNotifier event;
  final int gymId;
  final ItemScrollController itemScrollController;

   const TheOneWithCalendar({
    super.key,
    required this.event,
    required this.gymId,
    required this.itemScrollController,
  });


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final listOf15CalendarDaysFromNow = ref.watch(activityProvider).listOf15CalendarDaysFromNow;
        final daysInWhichWeHaveLessons =ref.watch(activityProvider).daysInWhichWeHaveLessons;
        final selectedCalendarDay = ref.watch(activityProvider).selectedCalendarDay;
        final loading = ref.watch(activityProvider).isSchedulesLoading;
        return /* loading ? const CalendarSkeleton() : */ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loading ?  SkeletonCard(width: 220.w):
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomText(
                text: "Выберите дату и удобное время",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
              child: SizedBox(
                  //color: Colors.green.shade300,
                  height: 75.h,
                  //padding: EdgeInsets.symmetric(vertical: 4.w),
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                    child: ScrollablePositionedList.builder(
                      itemCount: listOf15CalendarDaysFromNow.length,
                      scrollDirection: Axis.horizontal,
                      itemScrollController: itemScrollController,
                      itemBuilder: (context, index) {
                        final String currentDate = listOf15CalendarDaysFromNow[index];
                        bool isAvailable = daysInWhichWeHaveLessons.contains(currentDate);
                        bool isSelected = selectedCalendarDay == currentDate;
                        final parts = currentDate.split(" ");
                        if (loading) {
                          return Padding(
                          padding: EdgeInsets.only(right: 9.w),
                          child: SkeletonCard(width: 41, height: 70.h),
                        );
                        }
                        return GestureDetector(
                            onTap: () async {
                              if (isAvailable && currentDate != selectedCalendarDay) {
                                await event.setSelectedCalendarDay(currentDate);
                                event.getLessonsToShowAfterSelectingADay(currentDate);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 9.w),
                              child: AnimationButtonEffect(
                                disabled: isAvailable ? false : true,
                                child: SizedBox(
                                  //color: Colors.red,
                                  width: 41.w,
                                  child: Card(
                                    margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                                    shadowColor: const Color.fromRGBO(123, 163, 225, 0.73),
                                    elevation: isSelected ? 2.1 : 0,
                                    color: isSelected ? AppColors.blueColor : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(color: isSelected ? AppColors.blueColor
                                              : isAvailable ? AppColors.greyBorder : Colors.transparent,
                                          width: 1.w),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InterText(
                                          text: parts[0].toUpperCase(),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : isAvailable
                                                  ? Colors.black: const Color.fromRGBO(176, 176, 176, 1),
                                        ),
                                        3.verticalSpace,
                                        CustomText(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            text: parts[1],
                                            color: isSelected
                                                ? Colors.white : isAvailable ? Colors.black
                                                    : const Color.fromRGBO(176, 176, 176, 1)),
                                        CustomText(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          text: parts[2],
                                          color: isSelected ? Colors.white : isAvailable
                                                  ? Colors.black : const Color.fromRGBO(176,176,176,1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),);
                      },
                    ),
                  ),
                  ),
            ),              
          ],
        );
      },
    );
  }
}

