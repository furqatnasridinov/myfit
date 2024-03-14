import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          singleBarItem(
            context,
            "/map",
            "assets/svg/map.svg",
            "Поиск занятий",
            () {
              if (context.router.stack
                  .any((element) => element.routeData.path == "/map")) {
                context.router.removeWhere((route) => route.path == "/map");
              }
              context.router.push(MapRoute(showOnlyKnown: false));
            },
          ),
          singleBarItem(
            context,
            "/notification",
            "assets/svg/notification2.svg",
            "Уведомления",
            () {
              if (context.router.stack.any(
                  (element) => element.routeData.path == "/notification")) {
                context.router
                    .removeWhere((route) => route.path == "/notification");
              }
              context.router.push(const NotificationRoute());
            },
          ),
          singleBarItem(
            context,
            "/schedule",
            "assets/svg/schedule.svg",
            "Расписание",
            () {
              if (context.router.stack
                  .any((element) => element.routeData.path == "/schedule")) {
                context.router
                    .removeWhere((route) => route.path == "/schedule");
              }
              context.router.push(const ScheduleRoute());
            },
          ),
        ],
      ),
    );
  }
}

Widget singleBarItem(
  BuildContext context,
  String routePath,
  String svgPath,
  String title,
  void Function()? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Column(children: [
      Container(
        width: 60.w,
        height: 30.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: context.router.currentPath == routePath
                ? AppColors.fadedPrimary3
                : Colors.white),
        child: SvgPicture.asset(svgPath),
      ),
      10.verticalSpace,
      CustomText(
        text: title,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.blueColor,
      )
    ]),
  );
}
