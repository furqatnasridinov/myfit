// ignore_for_file: use_build_context_synchronously
import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/models/data/chips_model.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithCalendar extends StatefulWidget {
  final ActivityNotifier event;

  const TheOneWithCalendar({
    super.key,
    required this.event,
  });

  @override
  State<TheOneWithCalendar> createState() => _TheOneWithCalendarState();
}

final List<ChipsModel> podActives = [
  ChipsModel(text: "Показать всё", isActive: true),
  ChipsModel(text: "Общая тренировка"),
  ChipsModel(text: "Спарринг"),
  ChipsModel(text: "Зал"),
  ChipsModel(text: "Николай Борисович"),
];

class _TheOneWithCalendarState extends State<TheOneWithCalendar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            padding: EdgeInsets.only(left: 16.w),
            child: Container(
                //color: Colors.green.shade300,
                height: 75.h,
                padding: EdgeInsets.symmetric(vertical: 4.w),
                width: double.maxFinite,
                child: Consumer(builder: (context, ref, child) {
                  final listOf15CalendarDaysFromNow =
                      ref.watch(activityProvider).listOf15CalendarDaysFromNow;
                  final daysInWhichWeHaveLessons =
                      ref.watch(activityProvider).daysInWhichWeHaveLessons;
                  final selectedCalendarDay =
                      ref.watch(activityProvider).selectedCalendarDay;
                  return ListView.builder(
                    itemCount: listOf15CalendarDaysFromNow.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final String currentDate =
                          listOf15CalendarDaysFromNow[index];
                      bool isAvailable =
                          daysInWhichWeHaveLessons.contains(currentDate);
                      bool isSelected = selectedCalendarDay == currentDate;
                      final parts = currentDate.split(" ");
                      return GestureDetector(
                          onTap: () async {
                            if (isAvailable) {
                              await widget.event
                                  .setSelectedCalendarDay(currentDate);
                              widget.event.getLessonsToShowAfterSelectingADay(
                                currentDate,
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 9.w),
                            child: SizedBox(
                              //color: Colors.red,
                              width: 41.w,
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1.w, vertical: 2.h),
                                shadowColor:
                                    const Color.fromRGBO(123, 163, 225, 0.73),
                                elevation: isSelected ? 2.1 : 0,
                                color: isSelected
                                    ? AppColors.blueColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  side: BorderSide(
                                      color: isSelected
                                          ? AppColors.blueColor
                                          : isAvailable
                                              ? AppColors.greyBorder
                                              : Colors.transparent,
                                      width: 1.w),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InterText(
                                      text: parts[0].toUpperCase(),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : isAvailable
                                              ? Colors.black
                                              : const Color.fromRGBO(
                                                  176, 176, 176, 1),
                                    ),
                                    3.verticalSpace,
                                    CustomText(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        text: parts[1],
                                        color: isSelected
                                            ? Colors.white
                                            : isAvailable
                                                ? Colors.black
                                                : const Color.fromRGBO(
                                                    176, 176, 176, 1)),
                                    CustomText(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      text: parts[2],
                                      color: isSelected
                                          ? Colors.white
                                          : isAvailable
                                              ? Colors.black
                                              : const Color.fromRGBO(
                                                  176,
                                                  176,
                                                  176,
                                                  1,
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  );
                })),
          ),
          16.verticalSpace,

          // список занятий заведения на выбранный день
          Consumer(
            builder: (contex, ref, child) {
              final lessonsToShowAfterSelectingADay =
                  ref.watch(activityProvider).lessonsToShowAfterSelectingADay;
              final scheduleEvent = ref.read(scheduleProvider.notifier);
              if (lessonsToShowAfterSelectingADay.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomCard(
                    width: double.maxFinite,
                    child: CustomText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      text:
                          "В ближайшее время в заведении нет доступных занятий",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lessonsToShowAfterSelectingADay.length,
                  itemBuilder: (context, index) {
                    final currentSchedule =
                        lessonsToShowAfterSelectingADay[index];

                    return activityCard(
                      currentSchedule.canSignUp ?? false,
                      currentSchedule.id ?? 0,
                      currentSchedule.startTime ?? "??",
                      currentSchedule.endTime ?? "??",
                      currentSchedule.duration ?? "??",
                      currentSchedule.description ?? "??",
                      currentSchedule.lessonState ?? "",
                      () async {
                        await widget.event.enrollToGym(
                          context,
                          currentSchedule.id ?? 0,
                        );
                        // временно до вебсокетов
                        currentSchedule.lessonState = "WAITING";
                        setState(() {});
                        // get the updated list of lessons
                        scheduleEvent.getUsersSchedules(context);
                      },
                    );
                  },
                );
              }
            },
          ),

          15.verticalSpace,
        ],
      ),
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
                SizedBox(
                  child: InkWell(
                    onTap: (status == "OPEN" || status == "CANCELED_USER")
                        ? enrollFunction
                        : null,
                    child: CustomText(
                      text: AppHelpers().getStatusText(status),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppHelpers().getStatusTextColor(status),
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
