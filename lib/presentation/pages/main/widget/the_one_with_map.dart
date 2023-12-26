import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/pages/main/widget/map_inside_near_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithMap extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  const TheOneWithMap({
    super.key,
    required this.state,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    const int maxVisibleActivities = 4; // Максимум видимых элементов
    int remainingActivities =
        state.activitiesNearClient.length - maxVisibleActivities;

    List<Widget> activityWidgets = List.generate(
      (remainingActivities > 0)
          ? maxVisibleActivities
          : state.activitiesNearClient.length,
      (index) {
        final current = state.activitiesNearClient[index];
        return _tasks(
          current.activityName ?? "?",
          current.gymdata!.length.toString(),
          () {},
        );
      },
    );
    if (remainingActivities > 0) {
      activityWidgets.add(
        InkWell(
          onTap: () {
            //  Здесь должен быть ваш обработчик нажатия, который показывает остальные активности.
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.blueBorder)),
            child: InterText(
              text: "и еще ${remainingActivities.toString()}",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blueText,
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10.w,
            bottom: 10.h,
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
              Wrap(runSpacing: 10.w, spacing: 10.w, children: activityWidgets
                  /* List.generate(
                  state.activitiesNearClient.length,
                  (index) {
                    final current = state.activitiesNearClient[index];
                    return _tasks(
                      current.activityName ?? "?",
                      current.gymdata!.length.toString(),
                      () {},
                    );
                  },
                ), */
                  ),
              10.verticalSpace,
              MapInsideNearActivities(
                event: event,
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
        height: 24.h,
        //width: 120.w,
        //color: Colors.red,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
