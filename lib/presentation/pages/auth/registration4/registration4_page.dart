import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class Registration4Screen extends StatelessWidget {
  const Registration4Screen({super.key});

  Future<void> wait3SecondsThenMove(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3))
        .then((value) => context.router.replaceAll([
              const Main2Route(),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    wait3SecondsThenMove(context);
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
