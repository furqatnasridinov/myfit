// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PendingSchedules extends ConsumerWidget {
  const PendingSchedules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(scheduleProvider.notifier);
    final state = ref.watch(scheduleProvider);
    return state.waitingSchedules.isEmpty
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
                      text: "Ждем подтверждения",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        if (state.pendingSchedulesShown) {
                          event.hidePendingSchedules();
                        } else {
                          event.showPendingSchedules();
                        }
                      },
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.blueBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: state.pendingSchedulesShown
                                  ? "Свернуть"
                                  : "Развернуть",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            4.horizontalSpace,
                            Icon(
                              state.pendingSchedulesShown
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 20.sp,
                              color: Colors.black.withOpacity(0.7),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,

                // body
                if (state.pendingSchedulesShown)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.waitingSchedules.length,
                    itemBuilder: (context, index) {
                      return listOfActivitiesEachItem2(
                        context,
                        state.waitingSchedules[index].id,
                        state.waitingSchedules[index].time,
                        state.waitingSchedules[index].describtion,
                        state.waitingSchedules[index].gymName,
                        state.waitingSchedules[index].grade,
                        state.waitingSchedules[index].gymId,
                        event,
                      );
                    },
                  ),
              ],
            ),
          );
  }
}

Widget listOfActivitiesEachItem2(
  BuildContext context,
  final int id,
  final String time,
  final String description,
  final String name,
  final int grade,
  final int gymId,
  final ScheduleNotifier event,
) {
  return SizedBox(
    child: CustomCard(
      //color: Colors.green,
      marginBottom: 5.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top part
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // describtion
                SizedBox(
                  width: 220.w,
                  child: InterText(
                    text: description, //description,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                10.horizontalSpace,
                // three dots
                dropDownPending(
                  // navigate to activity page
                  () {
                    context.router.push(ActivityRoute(gymId: gymId));
                  },
                  // cancel lesson
                  () async {
                    await event.cancelActivity(id, context);
                    event.getUsersSchedules(context);
                  },
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
                SizedBox(
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
                        text: time,
                        color: AppColors.greyText,
                        fontSize: 12.sp,
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
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.blueColor,
                          size: 16.r,
                        ),
                        4.horizontalSpace,
                        Flexible(
                          child: SizedBox(
                            //width: 160.w,
                            //color: Colors.green,
                            child: InterText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              //text: "cmdkcmdkcmdkcmdkcmkdcmdmckmd,lcdl,cl,d,cd,lcdlc,,cl,dl,cdl,c",
                              text: name,
                              color: AppColors.greyText,
                              fontSize: 11.5.sp,
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
  );
}

Widget dropDownPending(
  void Function()? onNavigate,
  void Function()? onDelete,
) {
  return UiDropDownMenu(
    maxWidth: 300.w,
    customOffset: [-25.0.w, -25.h],
    dropDownItemsList: [
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
        'action': onNavigate,
      },
      {
        'title': 'Отменить запись',
        'icon': SvgPicture.asset(
          'assets/svg/close.svg',
          colorFilter: const ColorFilter.mode(
              Color.fromRGBO(255, 61, 0, 1), BlendMode.srcIn),
          height: 18.h,
          width: 18.w,
        ),
        'action': onDelete
      },
    ],

    dropDownChild: const Icon(
      Icons.more_vert,
      color: Colors.black,
    ),
    //
  );
}
