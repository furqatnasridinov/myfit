import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderComingActivity extends StatelessWidget {
  const PlaceholderComingActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final autoTabsRouter = AutoTabsRouter.of(context);
    return Container(
      height: 56.h,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(109, 150, 212, 1),
            offset: Offset(0, 15),
            blurRadius: 18,
            spreadRadius: -15,
          ),
        ],
      ),
      child: CustomButton(
        buttonColor: AppColors.blueColor,
        textColor: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        onPressed: () {
          autoTabsRouter.setActiveIndex(2);
        },
        onHover: (value){
          //print("hover $value");
        },
        text: "Найти себе занятие",
      ),
    );
  }
}
