// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/schedule/schedule_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/pages/activity/skeletons/lessons_skeleton.dart';
import '../../../../application/activity/activity_provider.dart';

class TheOneWithLessons extends StatelessWidget {
  final int gymId;
  const TheOneWithLessons({super.key, required this.gymId});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (contex, ref, child) {
        final event = ref.read(activityProvider.notifier);
        //final isEnrollingError = ref.watch(activityProvider).isEnrollingError;
        final lessonsToShowAfterSelectingADay =ref.watch(activityProvider).lessonsToShowAfterSelectingADay;
        final scheduleEvent = ref.read(scheduleProvider.notifier);
        final int visitPerMonth = ref.watch(activityProvider).gym?.visitPerMonth ?? 0;
        final int visitedCount = ref.watch(activityProvider).gym?.visitedCount ?? 0;
        final loading = ref.watch(activityProvider).isSchedulesLoading;
        final int visitRemaining = visitPerMonth - visitedCount;
        if (lessonsToShowAfterSelectingADay.isEmpty && !loading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 16.h),
            child: CustomCard(
              width: double.maxFinite,
              child: CustomText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                text: "В ближайшее время в заведении нет доступных занятий",
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return loading
              ? const LessonsSkeleton()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lessonsToShowAfterSelectingADay.length,
                  itemBuilder: (context, index) {
                    final currentSchedule =lessonsToShowAfterSelectingADay[index];
                    return activityCard(
                      currentSchedule.canSignUp ?? false,
                      currentSchedule.id ?? 0,
                      currentSchedule.startTime ?? "??",
                      currentSchedule.endTime ?? "??",
                      currentSchedule.duration ?? "??",
                      currentSchedule.description ?? "??",
                      currentSchedule.lessonState ?? "",
                      currentSchedule.isLoading,
                      visitRemaining <= 0,
                      () async {
                        currentSchedule.isLoading = true;
                        await event.enrollToGym(context, currentSchedule.id ?? 0);
                        /* if (currentSchedule.autoAccept == true) {
                          await event.getAllLessons(context, false,  id: gymId);
                          await event.getLessonsOfSelectedActivity(currentSchedule.lessonType ?? "", false);
                          currentSchedule.isLoading = false;
                        }else if(currentSchedule.autoAccept == false){
                          if (isEnrollingError == false) {
                            currentSchedule.lessonState = "WAITING";
                          }
                          currentSchedule.isLoading = false;
                        } */
                        //get the updated list of lessons
                        await event.getAllLessons(context, false,  id: gymId);
                        await event.getLessonsOfSelectedActivity(currentSchedule.lessonType ?? "", false);
                        currentSchedule.isLoading = false;
                        scheduleEvent.getUsersSchedules(context);
                        // to add this lessontype to known lessontypes if it's not there
                        ref.read(settingsProvider.notifier).getWaitingLessonTypes(context);
                      },
                    );
                  },
                );
        }
      },
    );
  }
}



Widget activityCard(
  bool canSignUp,
  int id,
  String startTime,
  String finishTime,
  String duration,
  String name,
  String? status,
  bool? isloading,
  cannotEnrollDueToVisitLimit,
  void Function()? enrollFunction,
) {
  if (canSignUp || (!canSignUp && status == "CONFIRMED")) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
      child: CustomCard(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // times
                SizedBox(
                  child: Row(
                    children: [
                      CustomText(
                        text: startTime,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      2.horizontalSpace,
                      const Text("-"),
                      2.horizontalSpace,
                      CustomText(
                        text: finishTime,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                // get status text
                Flexible(
                  child: GestureDetector(
                    onTap: (status == "OPEN" || status == "CANCELED_USER" || status == "CANCELED_GYM") &&
                            isloading == false && !cannotEnrollDueToVisitLimit
                        ? () {
                            enrollFunction?.call();
                          }
                        : null,
                    child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h)
                            .copyWith(left: 5.w),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final currentSub =
                                ref.watch(settingsProvider).currentSubscribtion;
                            return CustomText(
                              textAlign: TextAlign.right,
                              text: isloading == true
                                  ? "Отправка запроса..."
                                  : cannotEnrollDueToVisitLimit && (status != "CONFIRMED" && status != "COMPLETED")
                                      ? "Запись в это заведение будет доступна для вас ${currentSub?.endDataFormatted}"
                                      : AppHelpers().getStatusText(status),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: cannotEnrollDueToVisitLimit && (status != "CONFIRMED" && status != "COMPLETED")
                                  ? AppColors.greyText
                                  : AppHelpers().getStatusTextColor(status),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            InterText(
              text: name,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            5.verticalSpace,
            CustomText(
              text: duration,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyText,
            )
          ],
        ),
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}
