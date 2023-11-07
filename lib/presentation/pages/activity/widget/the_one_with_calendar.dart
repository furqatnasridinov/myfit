import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithCalendar extends StatefulWidget {
  final ActivityState state;
  final ActivityNotifier event;

  const TheOneWithCalendar(
      {super.key, required this.state, required this.event});

  @override
  State<TheOneWithCalendar> createState() => _TheOneWithCalendarState();
}

class _TheOneWithCalendarState extends State<TheOneWithCalendar> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
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
                  height: 80.h,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemExtent: 67,
                    itemCount:
                        widget.state.listOfFormattedDaysFrom1To30currentMonth.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final String currentDate =
                          widget.state.listOfFormattedDaysFrom1To30currentMonth[index];
                      bool isAvailable =
                          widget.state.availableFormattedDates.contains(currentDate);
                      final parts = currentDate.split(" ");
                      return GestureDetector(
                        onTap: () async {
                          isAvailable
                              ? widget.event.selectADay(currentDate)
                              : null;
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 8.w,
                                right: 8.w,
                                bottom: 8.h,
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
                                boxShadow: widget.state.selectedFormattedDay ==
                                        currentDate
                                    ? [
                                        const BoxShadow(
                                          //color: Colors.red,
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                          offset: Offset(0, 6),
                                          blurRadius: 3.5,
                                        ),
                                      ]
                                    : [],
                              ),
                              margin: EdgeInsets.only(right: 9.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      6.verticalSpace,
                                      CustomText(
                                        text: parts[0],
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: widget.state.selectedFormattedDay ==
                                                currentDate
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
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        text: parts[1],
                                        color: widget.state.selectedFormattedDay ==
                                                currentDate
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
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        text: parts[2],
                                        color: widget.state.selectedFormattedDay ==
                                                currentDate
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //3.verticalSpace,
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
                  child: widget.state.listOfSchedules.isEmpty
                      ? CustomText(
                          text: "Список занятий пуст!",
                          textAlign: TextAlign.center,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.state.listOfSchedules.length,
                          itemBuilder: (context, index) {
                            final currentSchedule = widget.state
                                .listOfSchedules[index] as Map<String, dynamic>;
                            String times = currentSchedule["date"];
                            List<String> parts = times.split("@");
                            final currentTime = parts[1];
                            final String endingTime = widget.event
                                .getEndingTime(
                                    currentTime, currentSchedule["duration"]);
                            /* final String endingTime = widget.event.getEndingTime(
                          "13:15", "01:30"); */
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // starting time
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColor,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
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
                                    16.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 226.w,
                                          child: CustomText(
                                            text:
                                                currentSchedule["description"],
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
