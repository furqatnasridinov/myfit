import 'dart:math';

import 'package:activity/application/map/map_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/pages/map/widget/pop_up_map.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../widget/widget.dart';

@RoutePage()
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  YandexMapController? yandexMapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(mapProvider.notifier)
        ..getUserLocation()
        ..getGymsList(context).then(
          (value) => ref.read(mapProvider.notifier)
            ..getAllMarkers()
            ..addUserLocationMarker(),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);
    final event = ref.read(mapProvider.notifier);
    print("markers count ${state.listOfMarkers.length}");
    print("active marker's name >> ${state.activeMarker?.name}");
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const MapHeader(),
      body: Column(
        children: [
          10.verticalSpace,
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Карта активностей
                const MapPageTopSection(),
                10.verticalSpace,
                // listview builder
                state.isloading
                    ? const SizedBox()
                    : MapListOfActivities(
                        yandexMapController,
                        event: event,
                        state: state,
                      ),
              ],
            ),
          ),

          // map
          Expanded(
            flex: 5,
            child: YandexMap(
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
                event.setInitialCameraPosition(
                  controller: yandexMapController!,
                );
              },
              onCameraPositionChanged: (cameraPosition, reason, finished) {
                if (reason == CameraUpdateReason.gestures) {
                  //print("onCameraPositionChanged gestures triggered");

                  event.removePopUp();
                }
              },
              onObjectTap: (geoObject) {
                print("geoObject is PlacemarkMapObject");
                if (geoObject is PlacemarkMapObject) {
                  final points = geoObject.geometry.map((e) {
                    return Point(
                      latitude: e.point!.latitude,
                      longitude: e.point!.longitude,
                    );
                  }).toList();
                  event
                      .setMarkerAsOpened(
                        points.first.latitude,
                        points.first.longitude,
                      )
                      .then(
                        (value) => event.showPopUpOnMap(context),
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
