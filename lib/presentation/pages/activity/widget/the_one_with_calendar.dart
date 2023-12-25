import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/models/data/chips_model.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithCalendar extends StatefulWidget {
  final ActivityState state;
  final ActivityNotifier event;

  const TheOneWithCalendar({
    super.key,
    required this.state,
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
            padding: EdgeInsets.symmetric(vertical: 6.w),
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
                      child: SizedBox(
                        width: 41.w,
                        child: Card(
                          shadowColor:
                              const Color.fromRGBO(123, 163, 225, 0.73),
                          elevation:
                              widget.state.selectedFormattedDay == currentDate
                                  ? 2.1
                                  : 0,
                          color:
                              widget.state.selectedFormattedDay == currentDate
                                  ? AppColors.blueColor
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(
                                color: widget.state.selectedFormattedDay ==
                                        currentDate
                                    ? AppColors.blueColor
                                    : isAvailable
                                        ? AppColors.blueBorder
                                        : Colors.transparent,
                                width: 1.w),
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
                                          : const Color.fromRGBO(
                                              176, 176, 176, 1)),
                              CustomText(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  text: parts[1],
                                  color: widget.state.selectedFormattedDay ==
                                          currentDate
                                      ? Colors.white
                                      : isAvailable
                                          ? Colors.black
                                          : const Color.fromRGBO(
                                              176, 176, 176, 1)),
                              CustomText(
                                fontSize: 10.sp,
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
                        ),
                      ),
                    ));
              },
            ),
          ),
          10.verticalSpace,

          // подактивности (Блок с подактивностями скрывается,
          //если владелец заведения их не добавил.)
          widget.state.listOfSchedules.isEmpty &&
                  widget.state.selectedFormattedDay.isEmpty
              ? CustomCard(
                  width: double.maxFinite,
                  child: CustomText(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    text: "В ближайшее время в заведении нет доступных занятий",
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${widget.state.selectedActivity}",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    10.verticalSpace,
                    Wrap(
                      runSpacing: 5.h,
                      spacing: 5.w,
                      children: List.generate(podActives.length, (index) {
                        final current = podActives[index];
                        return InkWell(
                          onTap: () {
                            if (!current.isActive!) {
                              for (var element in podActives) {
                                if (element.isActive!) {
                                  element.isActive = false;
                                  setState(() {});
                                }
                              }
                              current.isActive = true;
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: current.isActive!
                                    ? Colors.transparent
                                    : AppColors.blueBorder,
                              ),
                              color: current.isActive!
                                  ? AppColors.blueColor
                                  : Colors.white,
                            ),
                            child: CustomText(
                              text: current.text,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: current.isActive!
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

          10.verticalSpace,
          // список занятий заведения на выбранный день
          Consumer(
            builder: (contex, ref, child) {
              final main2Event = ref.read(main2Provider.notifier);
              final scheduleevent = ref.read(scheduleProvider.notifier);
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.state.listOfSchedules.length,
                itemBuilder: (context, index) {
                  final currentSchedule = widget.state.listOfSchedules[index];
                  return activityCard(
                    currentSchedule.id,
                    currentSchedule.startingTime ?? "??",
                    currentSchedule.finishingTime ?? "??",
                    currentSchedule.duration ?? "??",
                    currentSchedule.name ?? "??",
                    currentSchedule.status ?? 0,
                    () async {
                      widget.event.enrollToGym(
                        context,
                        currentSchedule.id,
                      );
                      currentSchedule.status = 2;
                      setState(() {});
                      await Future.delayed(const Duration(seconds: 2));
                      currentSchedule.status = 3;
                      setState(() {});
                      // ignore: use_build_context_synchronously
                      main2Event.getNearestLesson(context);
                      // ignore: use_build_context_synchronously
                      scheduleevent.getUsersSchedules(context);
                    },
                  );
                },
              );
            },
          ),

          15.verticalSpace,
        ],
      ),
    );
  }
}

Widget activityCard(
  int id,
  String startTime,
  String finishTime,
  String duration,
  String name,
  int status,
  void Function()? enrollFunction,
) {
  return CustomCard(
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
            SizedBox(
              child: status == 1
                  ? InkWell(
                      onTap: enrollFunction,
                      child: CustomText(
                        text: "Записаться",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blueText,
                      ),
                    )
                  : status == 2
                      ? CustomText(
                          text: "Ждём ответ от заведения",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyText,
                        )
                      : Row(
                          children: [
                            CustomText(
                              text: "Вы записаны",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            5.horizontalSpace,
                            Icon(
                              Icons.done,
                              color: Colors.black,
                              size: 16.r,
                            )
                          ],
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
  );
}
