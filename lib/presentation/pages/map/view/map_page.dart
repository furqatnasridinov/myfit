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
                  ? Column(
                      children: [
                        10.verticalSpace,
                        MapPageTopSection(
                          event: event,
                          state: state,
                        ),
                        10.verticalSpace,
                      ],
                    )
                  : ListView(children: [
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
                YandexMap(
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
                  onCameraPositionChanged: (cameraPosition, reason, finished) {
                    if (reason == CameraUpdateReason.gestures) {
                      event.removePopUp();
                    }
                  },
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
                              /* Icon(
                                state.showMapOnly
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                size: 18.r,
                              ), */
                              15.horizontalSpace,
                            ],
                          )),
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
