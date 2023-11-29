import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapListOfActivities extends StatelessWidget {
  final MapState state;
  final MapNotifier event;
  YandexMapController? controller;

  MapListOfActivities(
    this.controller, {
    super.key,
    required this.state,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return state.listOfActivitiesFromSelectedDiapozone.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
            child: CustomCard(
              child: CustomText(
                text:
                    "В этом радиусе ничего не найдено, увеличьте радиус поиска.",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
            itemCount: state.listOfActivitiesFromSelectedDiapozone.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final currentActivity =
                  state.listOfActivitiesFromSelectedDiapozone[index];
              //print("eachData ${eachData[index]["name"]}");
              return _listBuilder(
                currentActivity.name,
                currentActivity.distanceFromClient!,
                "",
                () {
                  event.changeCameraPosition(
                    controller!,
                    currentActivity.latitude!,
                    currentActivity.longitude!,
                  );
                  event
                      .setMarkerAsOpened(
                        currentActivity.latitude!,
                        currentActivity.longitude!,
                      )
                      .then(
                        (value) => event.showPopUpOnMap(context),
                      );
                },
              );
            },
          );
  }

  _listBuilder(
    String? title,
    double distance,
    String? icon,
    void Function()? onTap,
  ) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.greyBorder, width: 1.w),
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        title: CustomText(
          text: title ?? "",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        trailing: CustomText(
          text: "${distance.toString()} km",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        leading: SvgPicture.asset(
          icon == "" ? "assets/svg/activity.svg" : icon ?? "",
          width: 24.w,
          height: 24.h,
          color: AppColors.blueColor,
        ),
      ),
    );
  }
}
