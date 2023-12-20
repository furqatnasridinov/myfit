import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithCalendar extends StatefulWidget {
  final ActivityState state;
  final ActivityNotifier event;
  final int gymId;

  const TheOneWithCalendar(
      {super.key,
      required this.state,
      required this.event,
      required this.gymId});

  @override
  State<TheOneWithCalendar> createState() => _TheOneWithCalendarState();
}

class _TheOneWithCalendarState extends State<TheOneWithCalendar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Выберите дату и удобное время",
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black,
          ),
          10.verticalSpace,
          Container(
            //color: Colors.red.shade300,
            height: 80.h,
            padding: EdgeInsets.symmetric(vertical: 5.w),
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: widget.state.listOf15CalendarDaysFromNow.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final String currentDate =
                    widget.state.listOf15CalendarDaysFromNow[index];
                bool isAvailable =
                    widget.state.availableFormattedDates.contains(currentDate);
                final parts = currentDate.split(" ");
                return GestureDetector(
                  onTap: () async {
                    isAvailable ? widget.event.selectADay(currentDate) : null;
                    isAvailable
                        ? widget.event
                            .setSelectedOriginalDate(
                            currentDate,
                          )
                            .then(
                            (value) async {
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                            },
                          ).whenComplete(
                            () => widget.event.getSchedulesList(
                              widget.state.selectedOriginalDate,
                            ),
                          )
                        : null;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 9.w),
                    child: Container(
                      width: 41.w,
                      decoration: BoxDecoration(
                        color: widget.state.selectedFormattedDay == currentDate
                            ? AppColors.blueColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isAvailable
                              ? AppColors.greyBorder
                              : Colors.transparent,
                          width: 1.w,
                        ),
                        boxShadow: widget.state.selectedFormattedDay ==
                                currentDate
                            ? [
                                /* BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20.r, // Увеличьте размытие
                                  offset: Offset(
                                      0, 10.r), // Смещение вниз увеличено
                                  spreadRadius: -5
                                      .r, // Добавьте отрицательный spreadRadius
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(123, 163, 225, 0.73),
                                  blurRadius: 20.r, // Увеличьте размытие
                                  offset: Offset(
                                      0, 10.r), // Смещение вниз увеличено
                                  spreadRadius: -5
                                      .r, // Добавьте отрицательный spreadRadius
                                ), */
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InterText(
                              text: parts[0],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.state.selectedFormattedDay ==
                                      currentDate
                                  ? Colors.white
                                  : isAvailable
                                      ? Colors.black
                                      : const Color.fromRGBO(176, 176, 176, 1)),
                          CustomText(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              text: parts[1],
                              color: widget.state.selectedFormattedDay ==
                                      currentDate
                                  ? Colors.white
                                  : isAvailable
                                      ? Colors.black
                                      : const Color.fromRGBO(176, 176, 176, 1)),
                          CustomText(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            text: parts[2],
                            color:
                                widget.state.selectedFormattedDay == currentDate
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
                );
              },
            ),
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.r),
            //height: 300.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.greyBorder,
                width: 1.w,
              ),
            ),
            child: widget.state.listOfSchedules.isEmpty &&
                    widget.state.selectedFormattedDay.isEmpty
                ? CustomText(
                    text: "Список занятий пуст!",
                    textAlign: TextAlign.center,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.state.listOfSchedules.length,
                    itemBuilder: (context, index) {
                      final currentSchedule =
                          widget.state.listOfSchedules[index];
                      String times = currentSchedule["date"];
                      List<String> parts = times.split("@");
                      final currentTime = parts[1];
                      String calendarDay = widget.event
                          .formatOriginalToCalendarFullNames(parts[0]);
                      final String endingTime = widget.event.getEndingTime(
                          currentTime, currentSchedule["duration"]);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // starting time
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: REdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: CustomCard(
                                          height: 200.h,
                                          borderColor: Colors.transparent,
                                          width: double.maxFinite,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: "Подтверждение!",
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              16.verticalSpace,
                                              CustomText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                text:
                                                    'Вы действительно хотите записаться на занятия "${currentSchedule["description"]}" в $calendarDay - го числа?',
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: CustomButton(
                                                      buttonColor: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 30.h,
                                                      onPressed: () {
                                                        context.popRoute();
                                                      },
                                                      text: "Назад",
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  Expanded(
                                                    child: CustomButton(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      buttonColor:
                                                          AppColors.blueColor,
                                                      textColor: Colors.white,
                                                      height: 30.h,
                                                      onPressed: () {
                                                        // запись на трен
                                                        widget.event
                                                            .enrollToGym(
                                                                context,
                                                                currentSchedule[
                                                                    "id"]);
                                                      },
                                                      text: "Подтвердить",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      color: Colors.white,
                                      text: currentTime,
                                      //text: "12:45",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              16.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 226.w,
                                    child: CustomText(
                                      text: currentSchedule["description"],
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  1.verticalSpace,
                                  CustomText(
                                    text: "до $endingTime",
                                    color: AppColors.greyText,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          15.verticalSpace,
        ],
      ),
    );
  }
}
