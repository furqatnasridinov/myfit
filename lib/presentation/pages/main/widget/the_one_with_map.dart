import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ya_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithMap extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  const TheOneWithMap({super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    final _list = DummyData().listOFDummyActivities;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
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
                children: List.generate(state.gymsWithActivities.keys.length,
                    (index) {
                  return _tasks(
                      state.gymsWithActivities.keys.toList()[index], "2");
                }),
              ),
              10.verticalSpace,
              const UiYaMap(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tasks(
    String title,
    String count,
  ) {
    return Container(
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
              Icons.snowboarding,
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
    );
  }
}
