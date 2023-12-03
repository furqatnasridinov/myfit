import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderComingActivity extends StatelessWidget {
  const PlaceholderComingActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 56.h,
      buttonColor: AppColors.blueColor,
      textColor: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      onPressed: () {
        context.router.push(MapRoute(gymId: 0));
      },
      text: "Найти себе занятие",
    );
  }
}
