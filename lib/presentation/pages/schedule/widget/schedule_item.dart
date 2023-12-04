import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/pages/schedule/widget/drop_down_menu_inside_card.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleItemWidget extends StatelessWidget {
  final int id;
  final String time;
  final String description;
  final String duration;
  final String name;
  final ScheduleNotifier event;
  final ScheduleState state;

  const ScheduleItemWidget({super.key, 
    required this.time,
    required this.description,
    required this.duration,
    required this.name,
    required this.id,
    required this.event,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    List<String> split1 = time.split("@");
    List<String> split2 = split1[0].split("-");
    List<String> split3 = split1[1].split(":");
    final String year = split2[0];
    final String month = split2[1];
    final String day = split2[2];
    final String hour = split3[0];
    final String minute = split3[1];
    final DateTime timeFromServerCastedToDateTime = DateTime(
      int.parse(year),
      int.parse(month),
      int.parse(day),
      int.parse(hour),
      int.parse(minute),
    );
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
              //width: 310.w,
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
                          onTap: () {
                            if (state.showTillWhen) {
                              event.hideTilWhen();
                            } else {
                              event.showTilWhen();
                            }
                          },
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
}
