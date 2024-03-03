import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/pages/schedule/widget/drop_down_menu_inside_card.dart';
import 'package:activity/presentation/pages/schedule/widget/rate_dialog.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
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
    final state = ref.watch(scheduleProvider);
    return state.completedSchedules.isEmpty
        ? const SizedBox.shrink()
        : Column(
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
                  InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () {
                      if (state.completedSchedulesShown) {
                        event.hideCompletedSchedules();
                      } else {
                        event.showCompletedSchedules();
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
                            text: state.completedSchedulesShown
                                ? "Свернуть"
                                : "Развернуть",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          4.horizontalSpace,
                          Icon(
                            state.completedSchedulesShown
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
              if (state.completedSchedulesShown)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.completedSchedules.length,
                  itemBuilder: (context, index) {
                    return listOfActivitiesEachItem(
                        context,
                        state.completedSchedules[index].id,
                        state.completedSchedules[index].time,
                        state.completedSchedules[index].describtion,
                        state.completedSchedules[index].gymName,
                        state.completedSchedules[index].grade,
                        event);
                  },
                ),
            ],
          );
  }
}

Widget listOfActivitiesEachItem(
  BuildContext context,
  final int id,
  final String time,
  final String description,
  final String name,
  final int grade,
  final ScheduleNotifier event,
) {
  return SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
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
                          child: RateDialog(id: id),
                        );
                      });
                } else {
                  // delete rate
                  event.deleteRate(context, id: id);
                  // get new uodated list ??
                }
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
                      child: InterText(
                        text: id.toString(), //description,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    10.horizontalSpace,
                    // three dots
                    DropDownMenuInsideCard(
                      startingTimeInDateTime:
                          DateTime.now().subtract(Durations.extralong1),
                      onTap: () => context.router.push(
                        NotesRoute(
                          gymName: name,
                        ),
                      ),
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
      ],
    ),
  );
}
