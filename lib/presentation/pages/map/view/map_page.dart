// ignore_for_file: must_be_immutable
import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/pages/map/widget/pop_up_map.dart';
import 'package:myfit/presentation/pages/schedule/widget/widget.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
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
  const MapScreen({super.key});

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
      if (ref.watch(mapProvider).locationPermissionDenied) {
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
    final height = MediaQuery.of(context).size.height;
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    bool isAnyOpened = state.activitiesWithGymsInsideFromSelectedDiapozone
        .any((element) => element.isOpened);
    return PopScope(
      onPopInvoked: (didPop) async {
        if (state.showMapOnly) {
          event.reduceMap();
        }
        if (state.isGymsPopupShown) {
          event.removePopUp();
          event.showLocationButton();
        }
        return;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: ScheduleHeader(
            showNavigationButton: false,
            showBackButton: state.showOnlyKnown || state.showRecommended,
            height: height * 0.07 //12
            ),
        body: SafeArea(
          child: ListView(
            //shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // top section
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: height * state.topFlexValue,
                child: SizedBox(
                  child:  CustomScrollView(
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
                                  padding: EdgeInsets.only(bottom: 0.h)),
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

              // bottom section
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                height: state.isGymsPopupShown
                    ? height * (state.bottomFlexValue + 0.09)
                    : height * state.bottomFlexValue,
                child: Stack(
                  children: [
                    // map itself
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow:
                            state.activitiesWithGymsInsideFromSelectedDiapozone
                                            .length >
                                        5 &&
                                    (state.activitiesWithGymsInsideFromSelectedDiapozone
                                                .length >
                                            2 ||
                                        state.locationPermissionDenied) &&
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
                          //setState(() {});
                          if (state.userPosition == null) {
                            await event.getUserLocation();
                            // if permissions not granted
                            await event.setLocationFromSelectedCity();
                          }
                          event.setInitialCameraPosition(
                            controller: yandexMapController!,
                          );
                          // ignore: use_build_context_synchronously
                          await event.getGymsList(
                            context,
                            ref.watch(settingsProvider).knownActivities,
                            ref.watch(main2Provider).recommendedGyms,
                          );
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
                                        (value) =>
                                            event.showPopUpOnMap(context, ""),
                                      );
                                },
                              ),
                        /*  onCameraPositionChanged:
                            (cameraPosition, reason, finished) {
                          if (state.isGymsPopupShown &&
                              reason == CameraUpdateReason.gestures) {
                            event.removePopUp();
                            event.showLocationButton();
                          }
                          // when stops moving show pop up
                          if (finished) {
                            event.showPopUpOnMap(context);
                          }
                        }, */
                        logoAlignment: const MapAlignment(
                          horizontal: HorizontalAlignment.left,
                          vertical: VerticalAlignment.bottom,
                        ),
                      ),
                    ),

                    // show map only button
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: GestureDetector(
                          onTap: () {
                            if (state.showMapOnly) {
                              event.reduceMap();
                              event.setFlexes();
                            } else {
                              event.showMapOnly();
                              event.closeOpenedActivities();
                              if (state.isGymsPopupShown) {
                                event.removePopUp();
                                event.showLocationButton();
                              }
                            }
                          },
                          child: AnimationButtonEffect(
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
                    ),

                    // center location icon
                    Positioned(
                      right: 0.w,
                      bottom: (isAnyOpened && state.isLocationIconHidden)
                          ? 170.h
                          : state.isLocationIconHidden
                              ? 160.h
                              : 20.h,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: GestureDetector(
                          onTap: () {
                            event.locationButtonFunction(yandexMapController);
                          },
                          child: AnimationButtonEffect(
                            child: CustomCard(
                              height: 40.h,
                              width: 40.w,
                              radius: 8.r,
                              paddingAll: 8.r,
                              child: SvgPicture.asset(
                                "assets/svg/location_icon.svg",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // here we show bottom card of gyms
                    if (state.isGymsPopupShown)
                      Positioned(
                        bottom: 0,
                        child: PopUpMap(
                          name: state.activeMarker?.name ?? "??",
                          address: state.activeMarker?.address ?? "??",
                          onNavigate: () {
                            //event.removePopUp();
                            event.showLocationButton();
                            context.router.push(
                              ActivityRoute(
                                  gymId: state.activeMarker?.id ?? 0,
                                  isFromMap: true),
                            );
                          },
                          onCancel: () {
                            event.removePopUp();
                            event.showLocationButton();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
