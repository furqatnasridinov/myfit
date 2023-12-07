// ignore_for_file: must_be_immutable

import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/pages/map/widget/no_gyms_in_diapozone.dart';
import 'package:activity/presentation/pages/map/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapListOfActivities extends StatefulWidget {
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
  State<MapListOfActivities> createState() => _MapListOfActivitiesState();
}

class _MapListOfActivitiesState extends State<MapListOfActivities> {
  @override
  Widget build(BuildContext context) {
    return widget.state.isloading
        ? const SearchingActivitiesCard()
        : widget.state.activitiesWithGymsInsideFromSelectedDiapozone.isEmpty &&
                !widget.state.isloading
            ? NoGymsInSelectedDiapozone(
                state: widget.state, event: widget.event)
            : SizedBox(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w)
                      .copyWith(bottom: 10.h),
                  itemCount: widget.state
                      .activitiesWithGymsInsideFromSelectedDiapozone.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final currentActivity = widget.state
                        .activitiesWithGymsInsideFromSelectedDiapozone[index];
                    return _listOfActivitiesBuilder(
                        currentActivity.lessontype ?? "??",
                        currentActivity.listOfGyms!.length.toString(),
                        currentActivity.isOpened,
                        currentActivity.listOfGyms!,
                        // ontap of gyms below
                        () {
                      for (var element in widget.state
                          .activitiesWithGymsInsideFromSelectedDiapozone) {
                        if (element.isOpened == true &&
                            element != currentActivity) {
                          element.isOpened = false;
                          setState(() {});
                        }
                      }
                      currentActivity.isOpened = !currentActivity.isOpened;
                      setState(() {});
                      widget.event.openCloseGymsList();
                    });
                  },
                ),
              );
  }

  _listOfActivitiesBuilder(
    String title,
    String countOfGyms,
    bool isOpened,
    List<Gymdata> gymsList,
    void Function()? onTap,
  ) {
    return Container(
      //height: 40.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.greyBorder, width: 1.w),
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: ListTile(
              leading: SizedBox(
                width: 24.sp,
                height: 24.sp,
                child: Icon(
                  Icons.snowboarding_rounded,
                  color: AppColors.blueColor,
                  size: 23.r,
                ),
              ),
              title: CustomText(
                text: title,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              trailing: SizedBox(
                //color: Colors.red.shade100,
                width: 100.w,
                child: Row(
                  children: [
                    // count of gyms
                    CustomText(
                      text: countOfGyms,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueColor,
                    ),
                    5.horizontalSpace,
                    Icon(
                      isOpened
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.blueColor,
                      size: 18.r,
                    ),
                    const Spacer(),
                    CustomText(
                      text: "${gymsList.first.distanceFromClient} км",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          isOpened
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //color: Colors.red,
                  height: gymsList.length > 2 ? 150.h : null,
                  child: ListView.builder(
                      itemCount: gymsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _listOfGymsBuilder(
                          gymsList[index].name,
                          gymsList[index].address,
                          gymsList[index].distanceFromClient ?? 3469,
                          "",
                          gymsList[index].isSelected,
                          () {
                            for (var element in gymsList) {
                              if (element.isSelected == true) {
                                element.isSelected = false;
                                setState(() {});
                              }
                            }
                            gymsList[index].isSelected =
                                !gymsList[index].isSelected;
                            setState(() {});
                            widget.event.changeCameraPosition(
                              widget.controller!,
                              double.parse(gymsList[index].latitude.toString()),
                              double.parse(
                                  gymsList[index].longitude.toString()),
                            );
                            widget.event
                                .setMarkerAsOpened(
                                  double.parse(
                                      gymsList[index].latitude.toString()),
                                  double.parse(
                                      gymsList[index].longitude.toString()),
                                )
                                .then((value) =>
                                    widget.event.showPopUpOnMap(context));
                          },
                        );
                      }),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

_listOfGymsBuilder(
  String? title,
  String? subTitle,
  double distance,
  String? icon,
  bool isSelected,
  void Function()? onTap,
) {
  return Container(
    //height: 40.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: isSelected ? AppColors.blueColor : AppColors.greyBorder,
        width: 1.w,
      ),
    ),
    margin: EdgeInsets.only(bottom: 5.h),
    child: ListTile(
      onTap: onTap,
      title: InterText(
        text: title ?? "",
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      subtitle: CustomText(
        text: subTitle ?? "",
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.greyText,
      ),
      trailing: CustomText(
        text: "${distance.toString()} km",
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.greyText,
      ),
    ),
  );
}
