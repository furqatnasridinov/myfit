// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_notifier.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/map/map_state.dart';
import 'package:myfit/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/pages/map/widget/no_gyms_in_diapozone.dart';
import 'package:myfit/presentation/pages/map/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MapListOfActivities extends StatefulWidget {
  final MapState state;
  final MapNotifier event;
  final Completer<GoogleMapController> controller;
  ScrollController activitiesListController;

  MapListOfActivities(
    this.activitiesListController, {
    super.key,
    required this.state,
    required this.event,
    required this.controller,
  });

  @override
  State<MapListOfActivities> createState() => _MapListOfActivitiesState();
}

class _MapListOfActivitiesState extends State<MapListOfActivities> {
  @override
  Widget build(BuildContext context) {
   /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.state.activitiesWithGymsInsideFromSelectedDiapozone.length >
              4 &&
          widget.state.activitiesWithGymsInsideFromSelectedDiapozone.last
              .isOpened) {
        widget.activitiesListController.animateTo(
          200,
          curve: Curves.linear,
          duration: const Duration(microseconds: 100),
        );
      }
    }); */
    return widget.state.isloading
        ? const SearchingActivitiesCard()
        : widget.state.activitiesWithGymsInsideFromSelectedDiapozone.isEmpty &&
                !widget.state.isloading
            ? NoGymsInSelectedDiapozone(
                state: widget.state, event: widget.event)
            : SizedBox(
                child: Column(
                children: [
                  if (widget.state.locationPermissionDenied ||
                      widget.state.locationServiceIsNotEnabled)
                    EnableLocationPermission(
                      event: widget.event,
                      state: widget.state,
                    ),
                  ListView.builder(
                    //controller: widget.activitiesListController,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: widget.state.activitiesWithGymsInsideFromSelectedDiapozone.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final currentActivity = widget.state.activitiesWithGymsInsideFromSelectedDiapozone[index];
                      return _listOfActivitiesBuilder(
                          currentActivity.lessontype ?? "??",
                          currentActivity.listOfGyms!.length.toString(),
                          currentActivity.isOpened,
                          currentActivity.listOfGyms!,
                          // ontap of gyms below
                          () {
                        currentActivity.isOpened = !currentActivity.isOpened;
                        if (!currentActivity.isOpened) {
                          widget.event.removePopUp();
                          widget.event.showLocationButton();
                          for (var element in currentActivity.listOfGyms!) {
                            if (element.isSelected == true) {
                              element.isSelected = false;
                            }
                          }
                        } else {
                          for (var el in widget.state.activitiesWithGymsInsideFromSelectedDiapozone) {
                            if (el.isOpened && el != currentActivity) {
                              el.isOpened = false;
                            }
                          }
                        }
                        widget.event.setFlexes();
                      });
                    },
                  ),
                ],
              ));
  }

  _listOfActivitiesBuilder(
    String title,
    String countOfGyms,
    bool isOpened,
    List<Gymdata> gymsList,
    void Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          height: isOpened ? (50.h + (gymsList.length * 52.h + 3.h)) : 42.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.greyBorder, width: 1.w),
          ),
          margin: EdgeInsets.only(bottom: 5.h),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: SizedBox(
                    height: 40.h,
                    //color: Colors.green,
                    child: Row(
                      children: [
                        SizedBox(
                          child: SvgPicture.asset(
                            AppHelpers().getIconSvg(title),
                            height: 15.h,
                          ),
                        ),
                        10.horizontalSpace,
                        CustomText(
                          text: title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        const Spacer(),
                        SizedBox(
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
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween(begin: 0, end: isOpened ? 1.0 : 0),
                                builder: (BuildContext context, double angle,
                                    Widget? child) {
                                  return Transform.rotate(
                                    angle: angle * pi,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18.sp,
                                      color: AppColors.blueColor,
                                    ),
                                  );
                                },
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
                      ],
                    ),
                  ),
                ),
                if (isOpened)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w)
                        .copyWith(top: 5.h),
                    child: SizedBox(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final activityEvent =
                              ref.read(activityProvider.notifier);
                          return ListView.builder(
                              itemCount: gymsList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _listOfGymsBuilder(
                                  gymsList[index].name,
                                  gymsList[index].address,
                                  gymsList[index].visitedCount,
                                  gymsList[index].visitPerMonth,
                                  gymsList[index].distanceFromClient ?? 3469,
                                  "",
                                  gymsList[index].isSelected,
                                  () {
                                    for (var element in gymsList) {
                                      if (element.isSelected == true) {
                                        element.isSelected = false;
                                        //setState(() {});
                                      }
                                    }
                                    gymsList[index].isSelected =
                                        !gymsList[index].isSelected;
                                    setState(() {});
                                    //
                                    activityEvent.getActivityTypes(
                                        context,
                                        false,
                                        ref
                                            .watch(mapProvider)
                                            .selectedLessonTypeFromMap,
                                        gymId: gymsList[index].id!);
                                    widget.controller.future.then((value) {
                                      value.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(
                                              double.parse(gymsList[index]
                                                  .latitude
                                                  .toString()),
                                              double.parse(gymsList[index]
                                                  .longitude
                                                  .toString())),
                                          zoom: 15.0,
                                        ),
                                      ));
                                    });
                                    widget.event
                                        .setSelectedGym(
                                          address: gymsList[index].address,
                                          id: gymsList[index].id,
                                          latitude: double.parse(
                                              gymsList[index].latitude ?? "0"),
                                          longitude: double.parse(
                                              gymsList[index].longitude ?? "0"),
                                          name: gymsList[index].name,
                                          visitPerMonth:
                                              gymsList[index].visitPerMonth,
                                          visitedCount:
                                              gymsList[index].visitedCount,
                                        )
                                        .then((value) => widget.event
                                            .showPopUpOnMap(context, title));
                                  },
                                );
                              });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}

_listOfGymsBuilder(
  String? title,
  String? subTitle,
  int? visitedCount,
  int? visitPerMonth,
  double distance,
  String? icon,
  bool isSelected,
  void Function()? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          //color: Colors.red,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.blueColor : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        child: SizedBox(
            //color: Colors.red,
            height: 47.h,
            width: double.maxFinite,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(
                  /* top: 7.h */),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210.w,
                    //color: Colors.amber,
                    child: InterText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: title ?? "",
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  //2.verticalSpace,
                  Row(
                    children: [
                      SizedBox(
                        width: 210.w,
                        //color: Colors.amber,
                        child: CustomText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: subTitle ?? "",
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyText,
                        ),
                      ),
                      CustomText(
                        text: "${distance.toString()} km",
                        //text: "$visitedCount / $visitPerMonth",
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                      const Spacer(),
                      AppHelpers().getBatteryIcon(
                          visitedCount ?? 0, visitPerMonth ?? 0),
                      //AppHelpers().getBatteryIcon(10, 12),
                    ],
                  ),
                ],
              ),
            )),
      ),
    ),
  );
}
