import 'dart:math';
import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Contacts extends StatelessWidget {
  final ActivityNotifier event;
  const Contacts({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Контакты",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  event.callTo("+79650292555");
                },
                child: SizedBox(
                  width: 165.w,
                  //color: Colors.red,
                  //height: 24.h,
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColors.blueColor),
                        padding: EdgeInsets.all(3.r),
                        child: SvgPicture.asset(
                          "assets/svg/phone_icon.svg",
                          // ignore: deprecated_member_use
                          color: Colors.white,
                        ),
                      ),
                      10.horizontalSpace,
                      CustomText(
                        text: "+7 (965) 029 25-55",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  event.launchTelegram();
                },
                child: SizedBox(
                  width: 165.w,
                  //color: Colors.red,
                  //height: 24.h,
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColors.blueColor),
                        padding: EdgeInsets.all(3.r),
                        child: Transform.rotate(
                          angle: pi * 90,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 14.r,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      CustomText(
                        text: "TopDogFC",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
