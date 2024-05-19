// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/pages/map/widget/pop_up_map.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import '../widget/widget.dart';

@RoutePage()
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  late ScrollController activitiesListController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
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
      if (ref.watch(mapProvider).userPosition == null) {
        ref.read(mapProvider.notifier).getUserLocation();
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
        _controller.future.then((controller) async {
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  ref.watch(mapProvider).userPosition!.latitude,
                  ref.watch(mapProvider).userPosition!.longitude,
                ),
                zoom: 14,
              ),
            ),
          );
        });
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
    ref.listen(mapProvider, (previous, next) {
      if (previous!.showRecommended != next.showRecommended &&
          !next.showRecommended) {
        _controller.future.then((controller) async {
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  ref.watch(mapProvider).userPosition!.latitude,
                  ref.watch(mapProvider).userPosition!.longitude,
                ),
                zoom: 14,
              ),
            ),
          );
        });
      }
    });
    bool isAnyOpened = state.activitiesWithGymsInsideFromSelectedDiapozone
        .any((element) => element.isOpened);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(showBackButton: state.showOnlyKnown || state.showRecommended, canNavigateToSettings: true, height: height * 0.07,),
      body: SafeArea(
        child: ListView(
          //shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // top section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.bottomCenter,
              curve: Curves.easeInOut,
              height: height * state.topFlexValue,
              child: SizedBox(
                child: CustomScrollView(
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
                      SliverPadding(padding: EdgeInsets.only(bottom: 0.h)),
                      SliverToBoxAdapter(
                        child: MapListOfActivities(
                          activitiesListController,
                          event: event,
                          state: state,
                          controller: _controller,
                        ),
                      )
                    ]),
              ),
            ),
    
            // bottom section
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.bottomCenter,
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
                              ? event.getShadows()
                              : [],
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: GoogleMap(
                              padding: EdgeInsets.only(
                                  bottom: height *
                                      (state.showMapOnly ? 0.5 : 0.7)),
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              mapType: MapType.normal,
                              myLocationButtonEnabled: false,
                              //liteModeEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: event.getInitialLatLon(),
                                zoom: 15,
                              ),
                              onMapCreated:(GoogleMapController controller) async {
                                _controller.complete(controller);
                                await event.getGymsList(
                                  context,
                                  ref.watch(settingsProvider).knownActivities,
                                  ref.watch(mapProvider).recommendedGyms,
                                );
                                await event.getGetListOfGymsFromDiapozone();
                                event.setFlexes();
                                await event.getAllMarkers();
                                await event.addUserLocationMarker();
                              },
                              markers: state.listOfMarkers.isEmpty
                                  ? {}
                                  : state.listOfMarkers,
                            ),
                          ),
                        ],
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
                        : (state.isLocationIconHidden && !isAnyOpened)
                            ? 160.h
                            : 20.h,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          event.locationButtonFunction(_controller);
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
                    Consumer(builder: (context, ref, child) {
                      final isFromSearch = ref.watch(activityProvider).isFromSearch;
                      final selectedGym = ref.watch(mapProvider).selectedGym;
                      return Positioned(
                      bottom: 0,
                      child: PopUpMap(
                        name: selectedGym?.name ?? "??",
                        address: selectedGym?.address ?? "??",
                        visitPerMonth: selectedGym?.visitPerMonth ?? 0,
                        visitedCount: selectedGym?.visitedCount ?? 0,
                        onNavigate: () {
                          if (isFromSearch) {
                            ref.read(activityProvider.notifier).setIsFromSearch(false);
                          }
                          event.showLocationButton();
                          context.router.push(ActivityRoute(gymId: state.selectedGym?.id ?? 0,isFromMap: true));
                          event.removePopUp();
                        },
                        onCancel: () {
                          event.removePopUp();
                          event.showLocationButton();
                        },
                      ),
                    );
                    },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
