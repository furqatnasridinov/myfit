import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/radio_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiapozoneBottomSheet extends StatelessWidget {
  final MapNotifier event;
  final MapState state;
  const DiapozoneBottomSheet(
      {super.key, required this.event, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        // серая полоска
        Center(
          child: Container(
            width: 70.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.greyBorder,
              //color: Colors.red,
              borderRadius: BorderRadius.circular(2.r),
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
        CustomText(
          text: "Радиус поиска",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        20.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RadioButton700(
              title: '1 км',
              ontap: () {
                event.changeDiapozoneAndGetActivities(0, 1, context);
              },
              isSelected: state.listOfBool[0],
            ),
            Expanded(
              child: Divider(
                color: Colors.blue.shade100,
              ),
            ),
            RadioButton700(
                title: '2 км',
                ontap: () {
                  event.changeDiapozoneAndGetActivities(1, 2, context);
                },
                isSelected: state.listOfBool[1]),
            Expanded(
              child: Divider(color: Colors.blue.shade100),
            ),
            RadioButton700(
                title: '3 км',
                ontap: () {
                  event.changeDiapozoneAndGetActivities(2, 3, context);
                },
                isSelected: state.listOfBool[2]),
            Expanded(
              child: Divider(color: Colors.blue.shade100),
            ),
            RadioButton700(
              title: '5+ km',
              ontap: () {
                event.changeDiapozoneAndGetActivities(3, 5, context);
              },
              isSelected: state.listOfBool[3],
            ),
          ],
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
