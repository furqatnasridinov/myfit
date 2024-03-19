import 'package:activity/application/map/map_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class BottomNavigationHandlerScreen extends StatelessWidget {
  const BottomNavigationHandlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        const Main2Route(),
        const ScheduleRoute(),
        MapRoute(showOnlyKnown: false),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
            body: child,
            bottomNavigationBar: Consumer(
              builder: (context, ref, child) {
                final mapPageBottomCardShown =
                    ref.watch(mapProvider).isGymsPopupShown;
                return NavigationBar(
                  backgroundColor: Colors.white,
                  height: mapPageBottomCardShown ? 0 : 75.h,
                  elevation: 10,
                  selectedIndex: tabsRouter.activeIndex,
                  indicatorColor: AppColors.fadedPrimary3,
                  surfaceTintColor: Colors.transparent,
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  destinations: [
                    eachItem(
                      () {
                        tabsRouter.setActiveIndex(0);
                      },
                      "assets/svg/home.svg",
                      "Главная",
                      tabsRouter.activeIndex == 0,
                    ),
                    eachItem(
                      () {
                        tabsRouter.setActiveIndex(1);
                      },
                      "assets/svg/schedule.svg",
                      "Расписание",
                      tabsRouter.activeIndex == 1,
                    ),
                    eachItem(
                      () {
                        tabsRouter.setActiveIndex(2);
                      },
                      "assets/svg/map.svg",
                      "Поиск занятий",
                      tabsRouter.activeIndex == 2,
                    ),
                  ],
                );
              },
            ));
      },
    );
  }
}

Widget eachItem(
  void Function()? onTap,
  String svgPath,
  String title,
  bool active,
) {
  return GestureDetector(
    onTap: onTap,
    child: ColoredBox(
      color: Colors.white,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 60.w,
          height: 30.h,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: active ? AppColors.fadedPrimary3 : Colors.white,
          ),
          child: SvgPicture.asset(
            svgPath,
          ),
        ),
        6.verticalSpace,
        CustomText(
          text: title,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blueColor,
        ),
      ]),
    ),
  );
}
