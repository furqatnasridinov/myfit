import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/map/map_notifier.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/radio_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiapozoneBottomSheet extends StatelessWidget {
  final MapNotifier event;
  const DiapozoneBottomSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        // серая полоска
        Center(
          child: SizedBox(
            width: 70.w,
            height: 3.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.greyBorder,
                //color: Colors.red,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ),
        32.verticalSpace,
        // text Настройки поиска
        CustomText(
          text: "Настройки поиска",
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        32.verticalSpace,
        AnimationButtonEffect(
          child: SizedBox(
            height: 40.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.blueBorder)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // icon
                    SizedBox(width: 18.w, height: 18.h),
                    10.horizontalSpace,
                    CustomText(
                      text: "Сбросить фильтр на карте",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        32.verticalSpace,
        CustomText(
          text: "Радиус поиска",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        20.verticalSpace,
        Consumer(
          builder: (context, ref, child) {
            final double selectedDiapozone =
                ref.watch(mapProvider).selectedDiapozone;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RadioButton700(
                  title: '1 км',
                  ontap: () {
                    event.changeDiapozoneAndGetActivities(1, context);
                  },
                  isSelected: selectedDiapozone.toInt() == 1,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.blue.shade100,
                  ),
                ),
                RadioButton700(
                  title: '2 км',
                  ontap: () {
                    event.changeDiapozoneAndGetActivities(2, context);
                  },
                  isSelected: selectedDiapozone.toInt() == 2,
                ),
                Expanded(
                  child: Divider(color: Colors.blue.shade100),
                ),
                RadioButton700(
                  title: '3 км',
                  ontap: () {
                    event.changeDiapozoneAndGetActivities(3, context);
                  },
                  isSelected: selectedDiapozone.toInt() == 3,
                ),
                Expanded(
                  child: Divider(color: Colors.blue.shade100),
                ),
                RadioButton700(
                  title: '5+ km',
                  ontap: () {
                    event.changeDiapozoneAndGetActivities(5, context);
                  },
                  isSelected: selectedDiapozone.toInt() == 5,
                ),
              ],
            );
          },
        ),
        const Spacer(),
        CustomButton(
          height: 40.h,
          buttonColor: AppColors.blueColor,
          textColor: Colors.white,
          borderColor: AppColors.blueBorder,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          onPressed: () {
            context.popRoute();
          },
          text: "Вернуться к карте",
        ),
      ],
    );
  }
}
