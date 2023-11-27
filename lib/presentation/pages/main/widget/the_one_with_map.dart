import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/pages/main/widget/map_inside_near_activities.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithMap extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  final MapState mapState;
  const TheOneWithMap(
      {super.key,
      required this.state,
      required this.event,
      required this.mapState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            bottom: 10.0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'Рядом с вами есть чем заняться:',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.greyBorder,
              width: 1.w,
            ),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                runSpacing: 10.w,
                spacing: 10.w,
                children: List.generate(
                  state.activitiesNearClient.length,
                  (index) {
                    final current = state.activitiesNearClient[index];
                    return _tasks(
                      current.activityName ?? "?",
                      current.gymdata!.length.toString(),
                      () {
                        context.router.push(
                          MapRoute(
                            gymId: 0,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              10.verticalSpace,
              MapInsideNearActivities(
                
                event: event,
                mapState: mapState,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tasks(
    String title,
    String count,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 120.w,
        //color: Colors.red,
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColors.backgroundColor,
              ),
              child: Icon(
                title == "POOL"
                    ? Icons.waves
                    : title == "GYM"
                        ? Icons.sports_handball_sharp
                        : Icons.hotel_sharp,
                color: Colors.blue,
                size: 16.sp,
              ),
            ),
            3.horizontalSpace,
            InterText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            InterText(
              text: " - $count",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
