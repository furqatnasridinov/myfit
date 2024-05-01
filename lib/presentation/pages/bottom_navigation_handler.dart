import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
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
    final height = MediaQuery.of(context).size.height;
    return AutoTabsRouter(
      routes: const [
        Main2Route(),
        ScheduleRoute(),
        MapRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
            body: child,
            bottomNavigationBar: Consumer(
              builder: (context, ref, child) {
                final mapPageBottomCardShown =
                    ref.watch(mapProvider).isGymsPopupShown;
                final showOnlyKnownOnMap = ref.watch(mapProvider).showOnlyKnown;
                final recommendedShown = ref.watch(mapProvider).showRecommended;
                final event = ref.read(mapProvider.notifier);
                return NavigationBar(
                  backgroundColor: Colors.white,
                  height:
                      (mapPageBottomCardShown && tabsRouter.activeIndex == 2)
                          ? 0
                          : height * 0.09,
                  elevation: 10,
                  shadowColor: Colors.black,
                  selectedIndex: tabsRouter.activeIndex,
                  indicatorColor: AppColors.fadedPrimary3,
                  surfaceTintColor: Colors.transparent,
                  onDestinationSelected: (int index) {
                    if (index != 2 && showOnlyKnownOnMap) {
                      ref.read(mapProvider.notifier).removePopUp();
                    }
                  },
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
                      () async {
                        tabsRouter.setActiveIndex(2);
                        if (showOnlyKnownOnMap || recommendedShown) {
                          event.setShowOnlyKnown(false).then((value) => event.setShowRecommended(false))
                          .then((value) async {
                            await event.getGymsList(
                              context,
                              ref.watch(settingsProvider).knownActivities,
                              ref.watch(main2Provider).recommendedGyms,
                            );
                            await event.getGetListOfGymsFromDiapozone();
                            await event.setFlexes();
                            await event.getAllMarkers();
                            event.addUserLocationMarker();
                          });
                        }
                        if (mapPageBottomCardShown) {
                          ref.read(mapProvider.notifier)
                            ..removePopUp()
                            ..showLocationButton();
                        }
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
