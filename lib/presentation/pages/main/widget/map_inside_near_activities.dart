// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/map/map_provider.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/pages/main2/widget/main2_map_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapInsideNearActivities extends StatelessWidget {
  final MainNotifier event;
  MapInsideNearActivities({
    super.key,
    required this.event,
  });
  YandexMapController? yandexMapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 147.w,
      width: double.maxFinite,
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
      child: Consumer(
        builder: (context, ref, child) {
          final mapState = ref.watch(mapProvider);
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: mapState.isloading && mapState.mapScreenShot == null
                ? const Main2MapPlaceHolder()
                : Image.memory(
                    mapState.mapScreenShot ?? Uint8List(100),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Your fallback widget here
                      return SizedBox(
                        height: 147.h,
                        width: double.maxFinite,
                        child: Center(
                          child: CustomText(text: ""
                              //"Unable to load screenshot from Yandex Static API",
                              ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );

    /* Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.w,
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
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: 147.w,
          width: double.maxFinite,
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
    ); */
  }
}
