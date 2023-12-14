// ignore_for_file: must_be_immutable

import 'package:activity/application/map/map_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //settingInitDatas();
      /*    ref
          .read(mapProvider.notifier)
          .getUserLocation()
          .then(
            (value) => ref.read(mapProvider.notifier).getGymsList(
                  context,
                  widget.gymId!,
                ),
          )
          .then((value) =>
              ref.read(mapProvider.notifier)..getGetListOfGymsFromDiapozone())
          .whenComplete(() => ref.read(mapProvider.notifier).setFlexes())
          .then((value) => ref.read(mapProvider.notifier).getAllMarkers())
          .then((value) =>
              ref.read(mapProvider.notifier).addUserLocationMarker()); */
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkPermissionAndSetLocation();
    }
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    if (kDebugMode) {
      print("user position data ${state.userPosition}");
      print(
          "lenth ${state.activitiesWithGymsInsideFromSelectedDiapozone.length}");
      print("top flex ${state.topFlex}");
      print("bottom flex ${state.bottomFlex}");
      print("list of bool ${state.listOfBool}");
      print("markers count ${state.listOfMarkers.length}");
      print(
          "placemark lenth ${event.getPlacemarkObjects(onTap: (placemarkMapObject, point) {}).length}");
    }

    return Scaffold(
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
              //color: Colors.amber.shade200,
              //height: 200.h,
              child: state.showMapOnly
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: MapPageTopSection(
                        event: event,
                        state: state,
                      ),
                    )
                  : ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                          10.verticalSpace,
                          MapPageTopSection(
                            event: event,
                            state: state,
                          ),
                          10.verticalSpace,
                          MapListOfActivities(yandexMapController,
                              event: event, state: state)
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
                      if (state.userPosition == null) {
                        await event.getUserLocation();
                      }
                      await event.setLocationFromSelectedCity();
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
                              SvgPicture.asset(
                                state.showMapOnly
                                    ? "assets/svg/arrow_down.svg"
                                    : "assets/svg/arrow_up.svg",
                              ),
                              15.horizontalSpace,
                            ],
                          )),
                    ),
                  ),
                ),
                state.locationPermissionIsNOtGiven
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 21.w, bottom: 21.h),
                          child: InkWell(
                            onTap: () async {
                              if (!state.locationPermissionIsNOtGiven &&
                                  await yandexMapController
                                          ?.getCameraPosition() !=
                                      CameraPosition(
                                        target: Point(
                                            latitude:
                                                state.userPosition!.latitude,
                                            longitude:
                                                state.userPosition!.longitude),
                                      )) {
                                yandexMapController?.moveCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: Point(
                                        latitude: state.userPosition!.latitude,
                                        longitude:
                                            state.userPosition!.longitude,
                                      ),
                                    ),
                                  ),
                                  animation: const MapAnimation(duration: 1),
                                );
                              }
                            },
                            child: CustomCard(
                              height: 40.h,
                              width: 40.w,
                              paddingAll: 8.r,
                              child: SvgPicture.asset(
                                "assets/svg/location_icon.svg",
                                fit: BoxFit.contain,
                                height: 24.h,
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
    );
  }
}
