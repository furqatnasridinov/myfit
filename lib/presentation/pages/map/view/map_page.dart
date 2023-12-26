// ignore_for_file: must_be_immutable

import 'package:activity/application/map/map_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../widget/widget.dart';

@RoutePage()
class MapScreen extends ConsumerStatefulWidget {
  int? gymId;
  MapScreen(this.gymId, {super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  YandexMapController? yandexMapController;
  late ScrollController activitiesListController;
  bool wasLocationPermissionDenied = false;
  @override
  void initState() {
    super.initState();
    activitiesListController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ref.watch(mapProvider).showMapOnly) {
        ref.read(mapProvider.notifier).reduceMap();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    activitiesListController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      if (ref.watch(mapProvider).locationPermissionIsNOtGiven) {
        _checkLocationPermission();
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (wasLocationPermissionDenied) {
        checkPermissionAndSetLocation();
      }
      if (ref.watch(mapProvider).locationServiceIsNotEnabled) {
        listenToLocationService();
      }
    }
  }

  void _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    wasLocationPermissionDenied = permission == LocationPermission.denied;
  }

  Future<void> checkPermissionAndSetLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      ref.read(mapProvider.notifier).setUserPosition().then((value) async {
        await yandexMapController?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: ref.watch(mapProvider).userPosition!.latitude,
                longitude: ref.watch(mapProvider).userPosition!.longitude,
              ),
            ),
          ),
          animation: const MapAnimation(duration: 1),
        );
      });
    }
  }

  Future<void> listenToLocationService() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (isEnabled && ref.watch(mapProvider).locationServiceIsNotEnabled) {
      ref.read(mapProvider.notifier).setLocationServiceAsEnabled();
      checkPermissionAndSetLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    return PopScope(
      onPopInvoked: (didPop) {
        if (state.showMapOnly) {
          event.reduceMap();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: MapHeader(
          event: event,
          state: state,
        ),
        body: Column(
          children: [
            // top section
            Flexible(
              flex: state.topFlex,
              child: SizedBox(
                child: state.showMapOnly
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: MapPageTopSection(
                          event: event,
                          state: state,
                        ),
                      )
                    : CustomScrollView(
                        controller: activitiesListController,
                        slivers: [
                            SliverAppBar(
                              scrolledUnderElevation: 0,
                              automaticallyImplyLeading: false,
                              backgroundColor: AppColors.backgroundColor,
                              pinned: true,
                              elevation: 0,
                              floating: false,
                              flexibleSpace: FlexibleSpaceBar(
                                background: MapPageTopSection(
                                  event: event,
                                  state: state,
                                ),
                              ),
                            ),
                            SliverPadding(
                                padding: EdgeInsets.only(bottom: 10.h)),
                            SliverToBoxAdapter(
                              child: MapListOfActivities(
                                activitiesListController,
                                yandexMapController,
                                event: event,
                                state: state,
                              ),
                            )
                          ]),
              ),
            ),
            // map
            Flexible(
              //fit: FlexFit.tight,
              flex: state.bottomFlex,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: state.activitiesWithGymsInsideFromSelectedDiapozone
                                      .length >
                                  5 &&
                              (state.activitiesWithGymsInsideFromSelectedDiapozone
                                              .length >
                                          2 ||
                                      state.locationPermissionIsNOtGiven) &&
                                  !state.showMapOnly
                          ? const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0, 2),
                                blurRadius: 5,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Color(0xFF6D96D4),
                                offset: Offset(0, 15),
                                blurRadius: 18,
                                spreadRadius: -15,
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.39),
                                offset: Offset(0, -1),
                                blurRadius: 20.4,
                                spreadRadius: -2,
                              ),
                            ]
                          : [],
                    ),
                    child: YandexMap(
                      // on map created
                      onMapCreated: (controller) async {
                        debugPrint("onMapCreated called");
                        yandexMapController = controller;
                        setState(() {});
                        await event.getUserLocation();
                        if (state.userPosition == null ||
                            state.locationServiceIsNotEnabled) {
                          await event.setLocationFromSelectedCity();
                        }
                        event.setInitialCameraPosition(
                          controller: yandexMapController!,
                        );
                        // ignore: use_build_context_synchronously
                        await event.getGymsList(context, widget.gymId!);
                        await event.getGetListOfGymsFromDiapozone();
                        await event.setFlexes();
                        await event.getAllMarkers();
                        await event.addUserLocationMarker();
                      },
                      // map objects
                      mapObjects: state.listOfMarkers.isEmpty
                          ? []
                          : event.getPlacemarkObjects(
                              onTap: (placemarkMapObject, point) {
                                event
                                    .setMarkerAsOpened(
                                      placemarkMapObject.point.latitude,
                                      placemarkMapObject.point.longitude,
                                    )
                                    .then(
                                      (value) => event.showPopUpOnMap(context),
                                    );
                              },
                            ),

                      //
                      onCameraPositionChanged:
                          (cameraPosition, reason, finished) {
                        if (reason == CameraUpdateReason.gestures) {
                          event.removePopUp();
                        }
                      },
                      logoAlignment: const MapAlignment(
                          horizontal: HorizontalAlignment.left,
                          vertical: VerticalAlignment.bottom),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: InkWell(
                        onTap: () {
                          if (state.showMapOnly) {
                            event.reduceMap();
                            event.setFlexes();
                          } else {
                            event.showMapOnly();
                            event.closeOpenedActivities();
                          }
                        },
                        child: CustomCard(
                            radius: 8.r,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                15.horizontalSpace,
                                CustomText(
                                  text: state.showMapOnly
                                      ? "Показать список активностей"
                                      : "Карта на весь экран",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                10.horizontalSpace,
                                SizedBox(
                                  width: 18.w,
                                  height: 18.h,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      state.showMapOnly
                                          ? "assets/svg/arrow_down.svg"
                                          : "assets/svg/arrow_up.svg",
                                      width: 18.w,
                                      height: 18.h,
                                    ),
                                  ),
                                ),
                                15.horizontalSpace,
                              ],
                            )),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.w,
                    bottom: state.isLocationIconHidden ? 145.h : 10.h,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                      child: InkWell(
                        onTap: () {
                          event.locationButtonFunction(yandexMapController);
                        },
                        child: CustomCard(
                          height: 40.h,
                          width: 40.w,
                          radius: 8.r,
                          paddingAll: 8.r,
                          child: SvgPicture.asset(
                            "assets/svg/location_icon.svg",
                            fit: BoxFit.scaleDown,
                            //height: 24.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
