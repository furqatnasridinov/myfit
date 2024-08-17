import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/pages/main2/widget/stats_skeleton.dart';

class UserStatsBlock extends StatelessWidget {
  const UserStatsBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final statsForMonth = ref.watch(main2Provider).statsForMonth;
        final loading = ref.watch(main2Provider).statsMonthIsloading;
        if (loading) {
          return const StatsSkeleton();
        } 
        if (statsForMonth.isEmpty && !loading) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
          child: CustomCard(
            width: 171.w,
            //height: 143.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Ваша статистика за месяц",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
                10.verticalSpace,
                SizedBox(
                  //color: Colors.green,
                  //height: 73.h,
                  width: double.maxFinite,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
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
                                sections: showingSections(statsForMonth),
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
                      20.horizontalSpace,
                      // texts
                      Expanded(
                        child: Wrap(
                          runSpacing: 5.h,
                          spacing: 5.w,
                          children: List.generate(
                            statsForMonth.length,
                            (index) => _indicator(
                              AppHelpers().getColorOfActivity(
                                  statsForMonth[index].lessonType ?? ""),
                              statsForMonth[index].lessonType ?? "",
                            ),
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
      },
    );
  }

  List<PieChartSectionData> showingSections(
    List<UserStats> statsForMonth,
  ) {
    return List.generate(
      statsForMonth.length,
      (i) {
        const double radius = 4.0;
        return PieChartSectionData(
          radius: radius,
          value: double.parse(statsForMonth[i].count.toString()),
          showTitle: false,
          color: AppHelpers().getColorOfActivity(
            statsForMonth[i].lessonType ?? "",
          ),
        );
      },
    );
  }

  Widget _indicator(Color color, String text) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 6.w,
          height: 6.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
        5.horizontalSpace,
        CustomText(
          text: text,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ],
    );
  }
}
