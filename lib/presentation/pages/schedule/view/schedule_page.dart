import 'dart:math';

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/models/response/user_schedules_response.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/pages/schedule/widget/widget.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({
    super.key,
  });

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends ConsumerState<ScheduleScreen> {
  final List<String> allDayOfMonth = DummyData().days30;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(scheduleProvider.notifier).getUsersSchedules(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(scheduleProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: ScheduleHeader(
        event: event,
      ),
      body: /* state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : */
          SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: ScheduleTitle(),
              ),
            ),
            // body builder
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
              sliver: Consumer(builder: (context, ref, child) {
                final state = ref.watch(scheduleProvider);
                return SliverList.builder(
                  itemCount: allDayOfMonth.length,
                  itemBuilder: (context, index) {
                    final date =
                        allDayOfMonth[index]; // "2023-11-01" till "2023-11-15",
                    final formattedDay = event.formatDay(date); //  1 Ноября
                    final formattedDayOfWeek =
                        event.determineWeekday(date); // Понедельник
                    // Находим, есть ли расписание на этот день
                    UserSchedulesResponse? scheduleForDay;
                    for (var schedule in state.listOfuserSchedules) {
                      if (schedule.calendarDate == date) {
                        scheduleForDay = schedule;
                        break;
                      }
                    }
                    // Если расписание найдено, показываем itemListBuilder,
                    // иначе зеленый контейнер
                    if (scheduleForDay != null) {
                      return itemListBuilder(
                          context,
                          formattedDayOfWeek,
                          formattedDay,
                          scheduleForDay.listOfSchedules ?? [],
                          event);
                    } else {
                      return daysWithNoSchedule(
                        context,
                        formattedDayOfWeek,
                        formattedDay,
                        event,
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget itemListBuilder(
  BuildContext context,
  String dayOfWeek,
  String date,
  List<ListOfSchedules> listOfuserSchedules,
  ScheduleNotifier event,
) {
  return Container(
    //color: Colors.red,
    margin: EdgeInsets.only(bottom: 30.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // row (date and Plus button)
        Row(
          children: [
            CustomText(
              text: "$dayOfWeek, $date",
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            _plusButton(context, event),
          ],
        ),
        10.verticalSpace,
        // list
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listOfuserSchedules.length,
            itemBuilder: (context, index) {
              final current = listOfuserSchedules[index];
              return Consumer(builder: (context, ref, child) {
                final event = ref.read(scheduleProvider.notifier);
                final state = ref.watch(scheduleProvider);
                return listOfActivitiesEachItem(
                  context,
                  event,
                  state,
                  current.id ?? 0,
                  current.date ?? '',
                  current.description ?? "",
                  current.duration ?? "",
                  current.gym?.name ?? "",
                );
              });
            }),
      ],
    ),
  );
}

Widget daysWithNoSchedule(BuildContext context, String dayOfWeek, String date,
    ScheduleNotifier event) {
  return Container(
    //color: Colors.green,
    margin: EdgeInsets.only(bottom: 30.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "$dayOfWeek $date",
          fontWeight: FontWeight.w600,
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10.w,
            ),
            InterText(
              text: "На этот день ничего не запланировано",
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            _plusButton(context, event),
          ],
        ),
      ],
    ),
  );
}

Widget _plusButton(BuildContext context, ScheduleNotifier event) {
  return UiDropDownMenu(
    width: double.maxFinite,
    maxWidth: 255.w,
    customOffset: [-45.0.w, -40.0.h],
    dropDownItemsList: LocalStorage.getKnownActivities().isNotEmpty
        ? [
            {
              'title': 'Найти что то новое',
              'icon': SvgPicture.asset(
                "assets/svg/search.svg",
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': () =>
                  {context.router.push(MapRoute(showOnlyKnown: false))}
            },
            {
              'title': 'Выбрать из уже знакомых занятий',
              'icon': SvgPicture.asset(
                "assets/svg/copy.svg",
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': () => {
                    context.router.push(MapRoute(showOnlyKnown: true)),
                  }
            }
          ]
        : [
            {
              'title': 'Найти что то новое',
              'icon': SvgPicture.asset(
                "assets/svg/search.svg",
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': () =>
                  {context.router.push(MapRoute(showOnlyKnown: false))}
            }
          ],
    onOpenedAction: () => {event.triggerPlusState()},
    onClosedAction: () => {event.removePlusState()},
    dropDownChild: Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 1.w,
            color: AppColors.blueColor,
          ),
          color: AppColors.blueColor),
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(scheduleProvider);
        return Transform.rotate(
          angle: state.plusState == true ? (45 * pi / 180) : (0 * pi / 180),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 18.r,
          ),
        );
      }),
    ),
  );
}

Widget listOfActivitiesEachItem(
  BuildContext context,
  ScheduleNotifier event,
  final ScheduleState state,
  final int id,
  final String time,
  final String description,
  final String duration,
  final String name,
) {
  final DateTime timeFromServerCastedToDateTime = event.getDateTime(time);
  final String formattedTime = time.substring(time.length - 5);
  final String tillWhen = event.durationToTillWhen(formattedTime, duration);
  return SizedBox(
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // time
          Column(
            children: [
              InterText(
                text: formattedTime,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              9.verticalSpace,
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: SvgPicture.asset(
                  DateTime.now().isAfter(timeFromServerCastedToDateTime)
                      ? "assets/svg/completed.svg"
                      : "assets/svg/clock.svg",
                  fit: BoxFit.cover,
                ),
              ),
              7.verticalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: VerticalDivider(
                    color: AppColors.blueColor,
                    thickness: 1.w,
                  ),
                ),
              ),
            ],
          ),

          // custom card datas about schedules
          CustomCard(
            //color: Colors.green,
            marginBottom: 5.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top part
                SizedBox(
                  width: 265.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // describtion
                      SizedBox(
                        width: 220.w,
                        child: CustomText(
                          text: description,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.horizontalSpace,
                      // three dots
                      DropDownMenuInsideCard(
                        onTap: () => context.router.push(
                          NotesRoute(
                            gymName: name,
                          ),
                        ),
                        event: event,
                        id: id,
                        startingTimeInDateTime: timeFromServerCastedToDateTime,
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,

                // bottom part
                SizedBox(
                  width: 265.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // duration
                      InkWell(
                        /* onTap: () {
                          if (state.showTillWhen) {
                            event.hideTilWhen();
                          } else {
                            event.showTilWhen();
                          }
                        }, */
                        child: SizedBox(
                          //color: Colors.red,
                          child: Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: AppColors.blueColor,
                                size: 16.r,
                              ),
                              4.horizontalSpace,
                              InterText(
                                text: state.showTillWhen
                                    ? "до $tillWhen"
                                    : duration,
                                color: AppColors.greyText,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // location
                      SizedBox(
                        width: 200.w,
                        //color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.blueColor,
                              size: 16.r,
                            ),
                            4.horizontalSpace,
                            SizedBox(
                              width: 160.w,
                              //color: Colors.red,
                              child: InterText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: name,
                                color: AppColors.greyText,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
