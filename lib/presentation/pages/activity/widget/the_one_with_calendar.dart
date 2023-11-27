import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
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
    print("alo >> ${widget.state.listOfSchedules.first}");
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
          SizedBox(
            //color: Colors.red,
            height: 67.h,
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
                  child: Container(
                    width: 41.w,
                    height: 67.h,
                    padding: EdgeInsets.only(
                      left: 4.w,
                      right: 4.w,
                      bottom: 4.h,
                    ),
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
                      boxShadow:
                          widget.state.selectedFormattedDay == currentDate
                              ? [
                                  const BoxShadow(
                                    //color: Colors.red,
                                    spreadRadius: -2,
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(0, 6),
                                    blurRadius: 5.5,
                                  ),
                                ]
                              : [],
                    ),
                    margin: EdgeInsets.only(right: 9.w),
                    child: Column(
                      children: [
                        6.verticalSpace,
                        InterText(
                          text: parts[0],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
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
                        CustomText(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          text: parts[1],
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
                        1.verticalSpace,
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
                                                text:
                                                    'Вы действительно хотите записаться на занятия "${currentSchedule["description"]}" в $calendarDay - го числа?',
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              16.verticalSpace,
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
                                                      //height: 40.h,
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
                                                      //height: 40.h,
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
