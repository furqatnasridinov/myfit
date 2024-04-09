import 'package:activity/application/main2/main2_notifier.dart';
import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstTwoCards extends StatelessWidget {
  final Main2Notifier event;
  const FirstTwoCards({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // first container
        CustomCard(
            width: 171.w,
            height: 143.h,
            child: Consumer(builder: (context, ref, child) {
              final statsForMonth = ref.watch(main2Provider).statsForMonth;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    //height: 40.h,
                    //color: Colors.red,
                    child: CustomText(
                      text: "Статистика за месяц",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //15.verticalSpace,
                  statsForMonth.isEmpty
                      ? CustomText(
                          text: "Статистика пока недоступна",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        )
                      : SizedBox(
                          //color: Colors.green,
                          height: 73.h,
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // pie chart part
                              Container(
                                width: 62.w,
                                height: 62.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundColor,
                                  border: Border.all(
                                    color: AppColors.fadedBlueBorder,
                                    width: 1.w,
                                  ),
                                ),
                                padding: EdgeInsets.all(4.r),
                                child: Stack(
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sections:
                                            showingSections(statsForMonth),
                                      ),
                                    ),

                                    // heart icon
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.favorite,
                                        color: AppColors.goldText,
                                        size: 20.r,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // texts
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                //color: Colors.green,
                                width: 66.w,
                                height: 100.h,
                                child: ListView.builder(
                                  itemCount: statsForMonth.length,
                                  itemBuilder: (context, index) {
                                    return _indicator(
                                        event.getColors(index),
                                        statsForMonth[index].lessonType ??
                                            "??");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              );
            })),

        // second container
        Container(
          width: 169.w,
          height: 143.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.greyBorder, width: 1.w),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Ваш абонемент",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(6.r),
                  border:
                      Border.all(color: AppColors.fadedBlueBorder, width: 1.w),
                ),
                child: CustomText(
                  text: "121 день",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              /* Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(6.r),
                  border:
                      Border.all(color: AppColors.fadedBlueBorder, width: 1.w),
                ),
                child: CustomText(
                  text: "3275 баллов",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ), */
              CustomText(
                text: "Продлить",
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<UserStats> statsForMonth) {
    return List.generate(
      statsForMonth.length,
      (i) {
        const double radius = 4.0;
        return PieChartSectionData(
          radius: radius,
          value: double.parse(statsForMonth[i].count.toString()),
          showTitle: false,
          color: event.getColors(i),
        );
      },
    );
  }

  Widget _indicator(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: CustomText(
            text: text,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
