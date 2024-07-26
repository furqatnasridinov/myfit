import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/application/main/main_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/infrastructure/models/data/activity_near_client.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitiesNearby extends StatefulWidget {
  final List<ActivityNearClient> activitiesNearClient;
  const ActivitiesNearby({
    super.key,
    required this.activitiesNearClient,
  });

  @override
  State<ActivitiesNearby> createState() => _TheOneWithMapState();
}

class _TheOneWithMapState extends State<ActivitiesNearby> {

    int maxVisibleActivities = 4;
    BitmapDescriptor? icon;

    @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setIcon();
    },);
    super.initState();
  }

  Future<void> setIcon()async{
    icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1.w, 1.h)),
      "assets/images/map_icon_new.png");
    setState(() {});
  }
    
  @override
  Widget build(BuildContext context) {
    int remainingActivities = widget.activitiesNearClient.length - maxVisibleActivities;
    List<Widget> activityWidgets = List.generate(
      (remainingActivities > 0) ? maxVisibleActivities
          : widget.activitiesNearClient.length,
      (index) {
        final current = widget.activitiesNearClient[index];
        return _tasks(
          current.activityName ?? "?",
          current.gymdata!.length.toString(),
          () {},
        );
      },
    );

    // кнопка "и еще"
    if (remainingActivities > 0) {
      activityWidgets.add(
        InkWell(
          onTap: () {
            maxVisibleActivities = widget.activitiesNearClient.length;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.blueBorder)),
            child: InterText(
              text: "и еще ${remainingActivities.toString()}",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blueText,
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                bottom: 10.h,
              ),
              child: CustomText(
                text: 'Рядом с вами есть чем заняться:',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.greyBorder,
                  width: 1.w,
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(runSpacing: 10.w, spacing: 10.w, children: activityWidgets),
                  10.verticalSpace,
                  buildMap(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tasks(
    String title,
    String count,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 24.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColors.backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: SvgPicture.asset(
                  AppHelpers.getIconSvg(title),
                ),
              )
            ),
            3.horizontalSpace,
            InterText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            InterText(
              text: " - $count",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMap(){
    return Container(
      height: 147.w,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.w,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color.fromRGBO(119, 170, 249, 1),
            spreadRadius: -15,
            blurRadius: 18.0,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Consumer(builder: (context, ref, child) {
          final mapEvent = ref.read(mapProvider.notifier);
          final List<ActivityNearClient> activiesNear = ref.watch(mainProvider).activitiesNearClient;
          return GoogleMap(
          zoomControlsEnabled: false,
          liteModeEnabled: Platform.isAndroid ? true : false,
          compassEnabled: false,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition:  CameraPosition(
            target: mapEvent.getInitialLatLon(),
            zoom: 12,
          ),
          onTap: (argument) {
            // set radius to 3 
            mapEvent.changeDiapozoneAndGetActivities(3, context);
            AutoTabsRouter.of(context).setActiveIndex(2);

            /* if (showOnlyKnown) {
              mapEvent.setShowOnlyKnown(false);
            }
            if (showRecommended) {
              tabsRouter.setActiveIndex(2);
            } else {
              mapEvent.setShowRecommended(true);
              context.router.push(const MapRoute());
            } */
          },
         markers: activiesNear.expand((e) {
                  return e.gymdata!.map((gym) {
                    return Marker(
                      markerId: MarkerId(gym.id.toString()),
                      position: LatLng(double.parse(gym.latitude!),
                          double.parse(gym.longitude!)),
                      icon: icon ?? BitmapDescriptor.defaultMarker,
                    );
                  });
                }).toSet(),

        );
        },)
      ),
    );
  }
}
