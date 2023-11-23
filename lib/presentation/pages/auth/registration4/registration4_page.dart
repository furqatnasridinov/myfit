import 'package:activity/presentation/components/components.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class Registration4Screen extends StatelessWidget {
  const Registration4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Добро пожаловать в команду",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            38.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/MY.svg",
                  width: 120.w,
                ),
                5.horizontalSpace,
                SvgPicture.asset(
                  "assets/svg/FIT.svg",
                  width: 120.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
