import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapInsideNearActivities extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  final MapState mapState;
  MapInsideNearActivities({
    super.key,
    required this.state,
    required this.event,
    required this.mapState,
  });
  YandexMapController? yandexMapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.w,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(16.0),
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
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: 147.w,
          child: YandexMap(
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: false,
            mapObjects: event.getPlacemarkObjects(),
            onMapCreated: (controller) {
              yandexMapController = controller;
              yandexMapController?.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    zoom: 11,
                    target: Point(
                      latitude: mapState.userPosition!.latitude,
                      longitude: mapState.userPosition!.longitude,
                    ),
                  ),
                ),
                animation: const MapAnimation(
                  duration: 2,
                  type: MapAnimationType.linear,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
