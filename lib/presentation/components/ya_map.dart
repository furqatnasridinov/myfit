import 'package:activity/presentation/components/maphelpers/app_lat_long.dart';
import 'package:activity/presentation/components/maphelpers/location_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:yandex_mapkit/yandex_mapkit.dart';


class UiYaMap extends StatefulWidget {
  const UiYaMap({super.key});

  @override
  State<UiYaMap> createState() => _UiYaMap();
}

class _UiYaMap extends State<UiYaMap> {
  final mapControllerCompleter = Completer<YandexMapController>();

  final placemarksList = [
    const PlacemarkMapObject(
        mapId: MapObjectId('1321'),
        point: Point(latitude: 45.055755, longitude: 38.970497)),
  ];

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: Colors.white),
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
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: 147.0,
          child: YandexMap(
            mapObjects: placemarksList,
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
          ),
        ),
      ),
    );
  }

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }
}
