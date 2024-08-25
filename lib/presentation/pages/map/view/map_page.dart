// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:async';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart' as cluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/application/membership/membership_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/data/place_model.dart';
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

class _MapScreenState extends ConsumerState<MapScreen> with WidgetsBindingObserver {
  late ScrollController activitiesListController;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool wasLocationPermissionDenied = false;
  Set<Marker> markers = {};
  late cluster.ClusterManager? clusterManager;

  @override
  void initState() {
    super.initState();
    activitiesListController = ScrollController();
    clusterManager = initClusterManager();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initDatas();
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

  cluster.ClusterManager initClusterManager() {
    return cluster.ClusterManager<PlaceModel>(
        [], // empty while first init
        updateMarkers,
        markerBuilder: markerBuilder,
        extraPercent: 1,
        //maxDistParams: cluster.MaxDistParams(10.0),
        //stopClusteringZoom: 100.0,
        //levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0, 21.0, 23.0, 25.0, 27.0, 29.0, 31.0, 33.0, 35.0, 37.0, 39.0, 41.0],
        //clusterAlgorithm: cluster.ClusterAlgorithm.MAX_DIST
    );
  }

   Future<Marker> Function(cluster.Cluster) get markerBuilder =>
      (cluster) async {
        return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () {
              debugPrint(cluster.items.toString());
            },
            icon:  await ref.read(mapProvider.notifier).getClusterBitmap(
                text: cluster.isMultiple ? cluster.count.toString() : "",
                isMultiple: cluster.isMultiple,
                userAvatar: ref.watch(settingsProvider).avatar,
                isUser: ref.read(mapProvider.notifier).isUserLocation(cluster.location),
              ),
            );
      };

 void updateMarkers(Set<Marker> markers) {
   setState(() {
      this.markers = markers;
   });
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

  Future<void> initDatas() async {
    final Position? userPosition = ref.watch(mapProvider).userPosition;
    final event = ref.read(mapProvider.notifier);
    final ActivityNotifier activityNotifier = ref.read(activityProvider.notifier);
    event.setIsLoading(true);
    if (userPosition == null) {
      await event.getUserLocation();
    }
    await event.getGymsList(
      context,
      ref.watch(settingsProvider).knownActivities,
      ref.watch(mapProvider).recommendedGyms,
      gymIds: ref.watch(membershipProvider).gymIds,
    );
    await event.getGetListOfGymsFromDiapozone();
    event.setFlexes();
    event.setIsLoading(false);
    await event.addUserLocationMarker(
        avatar: ref.watch(settingsProvider).avatar);
    await event.getAllMarkers(context, activityNotifier: activityNotifier);
  }

  Future<void> checkPermissionAndSetLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final String avatar = ref.watch(settingsProvider).avatar;
      ref.read(mapProvider.notifier).setUserPosition(avatar: avatar).then((value) async {
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
        //clusterManager?.updateMap();
      });
    }else{
      // чтобы при повторном отказе не еще раз
      wasLocationPermissionDenied = false;
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    //final ActivityNotifier activityNotifier = ref.read(activityProvider.notifier);

    ref.listen(mapProvider, (previous, next) {
      if (previous!.showRecommended != next.showRecommended && !next.showRecommended) {
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

      // when we get the list of markers, we set them to cluster manager
      if (previous.listOfMarkers != next.listOfMarkers && next.listOfMarkers.isNotEmpty) {
        //clusterManager?.setItems(AppHelpers.getPlacemodels(next.listOfMarkers));
        //clusterManager?.updateMap();
      }
    });
    bool isAnyOpened = state.activitiesWithGymsInsideFromSelectedDiapozone.any((element) => element.isOpened);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(
        showBackButton: state.showOnlyKnown || state.showRecommended, 
        canNavigateToSettings: true, height: height * 0.07),
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
                      const SliverAppBar(
                        scrolledUnderElevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: AppColors.backgroundColor,
                        pinned: true,
                        elevation: 0,
                        floating: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: MapPageTopSection(),
                        ),
                      ),
                      //SliverPadding(padding: EdgeInsets.only(bottom: 0.h)),
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
                      boxShadow: state.activitiesWithGymsInsideFromSelectedDiapozone.length > 5 &&
                                  (state.activitiesWithGymsInsideFromSelectedDiapozone.length > 2 || 
                                  state.locationPermissionDenied) && !state.showMapOnly ? event.getShadows() : [],
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width,
                            height: height,
                            child: GoogleMap(
                              padding: EdgeInsets.only(
                                bottom:height * (state.showMapOnly ? 0.5 : 0.7),
                              ),
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              mapType: MapType.normal,
                              myLocationButtonEnabled: false,
                              buildingsEnabled: false,
                              mapToolbarEnabled: false,
                              //liteModeEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: event.getInitialLatLon(),
                                zoom: 15,
                              ),
                              onMapCreated:(GoogleMapController controller) async {
                                _controller.complete(controller);
                                clusterManager?.setMapId(controller.mapId);
                              },
                              onCameraMove: (position) {
                                //clusterManager?.onCameraMove(position);
                              },
                              //onCameraIdle: clusterManager?.updateMap,
                              markers: state.listOfMarkers //markers,
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
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: CustomCard(
                                radius: 8.r,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    15.horizontalSpace,
                                    CustomText(
                                      text: state.showMapOnly ? "Показать список активностей" : "Карта на весь экран",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    10.horizontalSpace,
                                    SizedBox(
                                      width: 18.w,
                                      height: 18.h,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          state.showMapOnly ? "assets/svg/arrow_down.svg" : "assets/svg/arrow_up.svg",
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
                  ),
    
                  // center location icon
                  Positioned(
                    right: 0.w,
                    bottom: (isAnyOpened && state.isLocationIconHidden)
                        ? 170.h: (state.isLocationIconHidden && !isAnyOpened) ? 160.h : 20.h,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          event.locationButtonFunction(
                            _controller,
                            avatar: ref.watch(settingsProvider).avatar,
                          );
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
