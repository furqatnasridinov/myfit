import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class SystemNotification extends StatelessWidget {
  final String lessonType;
  final bool unread;
  final String title;
  final String description;
  final String time;
  final String gymName;
  final int gymId;
  final Widget batteryIcon;
  const SystemNotification(
      {super.key,
      required this.lessonType,
      required this.unread,
      required this.title,
      required this.description,
      required this.time,
      required this.gymName,
      required this.gymId,
      required this.batteryIcon});

  @override
  Widget build(BuildContext context) {
    final bool visitRefreshed = title.contains("обновились посещения");
    //final bool membershipIsGoingToExpire = title.contains("закончится через");
    return CustomCard(
      marginBottom: 16.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if(visitRefreshed)
              _buildBatteryTitle(),
              if(!visitRefreshed)
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.r),
                    child: SvgPicture.asset(
                      _getSvgPath(title),
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  6.horizontalSpace,
                  InterText(
                    text: "Системное уведомление",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueText,
                  ),
                ],
              ),
              const Spacer(),
              if(unread)
              Row(
                children: [
                  SizedBox(
                    width: 6.w,
                    height: 6.h,
                    child: const DecoratedBox(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blueText,
                    )),
                  ),
                  5.horizontalSpace,
                  InterText(
                    text: "Новое",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueText,
                  ),
                ],
              ),
            ],
          ),
          16.verticalSpace,
          CustomText(
            text: title,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
          if(title != description)
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: CustomText(
              text: description,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
          ),
          16.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              //final isFromSeach = ref.watch(activityProvider).isFromSearch;
              return CustomButton(
                onPressed: () {
                  context.router.push(_getNextRoute(title, gymId: gymId));
                  /* if (isFromSeach) {
                    ref.read(activityProvider.notifier).setIsFromSearch(false);
                  }
                  context.router.push(ActivityRoute(gymId: gymId)); */
                },
                text: _getButtonText(title),
                buttonColor: Colors.white,
                textColor: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 40.h,
              );
            },
          ),
          12.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                "assets/svg/clock.svg",
                width: 16.w,
                height: 16.h,
              ),
              6.horizontalSpace,
              InterText(
                text: time,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText,
              ),
              /* const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/location.svg",
                    width: 16.w,
                    height: 16.h,
                  ),
                  2.horizontalSpace,
                  InterText(
                    text: gymName,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyText,
                  ),
                  6.horizontalSpace,
                  batteryIcon,
                ],
              ), */
            ],
          ),
        ],
      ),
    );
  }
}


Widget _buildBatteryTitle(){
  return Row(
    children: [
      SvgPicture.asset(
        "assets/svg/updatedBattery.svg",
        width: 24.w,
        height: 24.h,
      ),
      2.horizontalSpace,
      InterText(
        text: "Обновление!",
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.greyText,
      ),
    ],
  );
}

String _getButtonText(String title){
  if(title.contains("закончится через")){
    return "Настройка оплаты и автопродление";
  }
  return "Открыть карту заведений";
}

PageRouteInfo<dynamic> _getNextRoute(String title, {int gymId = 0}){
  if(title.contains("закончится через")){
    return const PaymentSettingsRoute();
  }
  return const MapRoute();
}

String _getSvgPath(String title){
  if(title.contains("закончится через")){
    return "assets/svg/card_icon.svg";
  }
  return "assets/svg/question2.svg";
}