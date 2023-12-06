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
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../widget/widget.dart';

@RoutePage()
class MapScreen extends ConsumerStatefulWidget {
  int? gymId;
  MapScreen(this.gymId, {super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  YandexMapController? yandexMapController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
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
          .whenComplete(
            () => ref.read(mapProvider.notifier).getAllMarkers(),
          )
          .then((value) =>
              ref.read(mapProvider.notifier).addUserLocationMarker());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    if (kDebugMode) {
      print(
          "activities with gyms inside lenth ${state.activitiesWithGymsInsideFromSelectedDiapozone.length}");
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MapHeader(
        event: event,
        state: state,
      ),
      body: state.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                10.verticalSpace,
                // Карта активностей
                MapPageTopSection(
                  event: event,
                  state: state,
                ),
                10.verticalSpace,
                // listview builder
                state.showMapOnly
                    ? const SizedBox()
                    : state.isloading
                        ? const SizedBox()
                        : MapListOfActivities(
                            yandexMapController,
                            event: event,
                            state: state,
                          ),

                // map
                Flexible(
                  //flex: 5,
                  child: Stack(
                    children: [
                      YandexMap(
                        // map objects
                        mapObjects: event.getPlacemarkObjects(
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

                        // on map created
                        onMapCreated: (controller) {
                          yandexMapController = controller;
                          setState(() {});
                          event.setInitialCameraPosition(
                            controller: yandexMapController!,
                          );
                        },
                        //
                        onCameraPositionChanged:
                            (cameraPosition, reason, finished) {
                          if (reason == CameraUpdateReason.gestures) {
                            event.removePopUp();
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: CustomCard(
                              radius: 8.r,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  15.horizontalSpace,
                                  InkWell(
                                    onTap: () {
                                      if (state.showMapOnly) {
                                        event.reduceMap();
                                      } else {
                                        event.showMapOnly();
                                      }
                                    },
                                    child: CustomText(
                                      text: state.showMapOnly
                                          ? "Показать список активностей"
                                          : "Карта на весь экран",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    state.showMapOnly
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    size: 18.r,
                                  ),
                                  15.horizontalSpace,
                                ],
                              )),
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
