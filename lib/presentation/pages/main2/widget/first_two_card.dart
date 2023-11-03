import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';

class FirstTwoCards extends StatelessWidget {
  FirstTwoCards({super.key});
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // first container
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
                text: "Статистика за месяц",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                //color: Colors.red,
                height: 63.h,
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
                              sections: showingSections(),
                            ),
                          ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _indicator(AppColors.goldText, "Бассейн"),
                        _indicator(AppColors.purpleText, "Силовые"),
                        _indicator(AppColors.blueColor, "Массаж"),
                        _indicator(Colors.grey.shade400, "Другое"),
                        1.verticalSpace,
                      ],
                    )
                  ],
                ),
              ),
              CustomText(
                text: "Детальная статистика",
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ],
          ),
        ),

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
                  text: "3275 баллов",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      //final isTouched = i == touchedIndex;
      final radius = 4.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.goldText,
            value: 40,
            showTitle: false,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.purpleText,
            value: 30,
            showTitle: false,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.blueColor,
            value: 30,
            showTitle: false,
            radius: radius,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.grey.shade400,
            //value: 35,
            showTitle: false,
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }

  Widget _indicator(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        10.horizontalSpace,
        CustomText(
          text: text,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
