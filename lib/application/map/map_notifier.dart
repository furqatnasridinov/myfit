import 'package:activity/application/map/map_state.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/presentation/pages/map/widget/pop_up_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier(this._mainRepositoryInterface) : super(const MapState());
  final MainRepositoryInterface _mainRepositoryInterface;
  OverlayEntry? entry;

  Future<void> getUserLocation() async {
    state = state.copyWith(isloading: true);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    final postion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    state = state.copyWith(userPosition: postion);
    state = state.copyWith(isloading: false);
    print("position longitude ${postion.longitude}");
    print("position latitude ${postion.latitude}");
  }

  void setInitialCameraPosition({required YandexMapController controller}) {
    if (state.userPosition != null) {
      // move to user location
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 11.5,
            target: Point(
              latitude: state.userPosition!.latitude,
              longitude: state.userPosition!.longitude,
            ),
          ),
        ),
        animation: const MapAnimation(duration: 2),
      );
    } else {
      // move to fixed location      // Москва 55.755825  37.617519
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            zoom: 15.5,
            target: Point(
              latitude: 55.755825,
              longitude: 37.617519,
            ),
          ),
        ),
        animation: const MapAnimation(duration: 3),
      );
    }
  }

  void getAllMarkers() {
    List<EachMarkersModel> markers = [];
    state.listOfActivities.forEach((element) {
      final marker = EachMarkersModel(
        name: element.name ?? "",
        latitude: element.latitude ?? 0,
        longitude: element.longitude ?? 0,
        address: element.address ?? "",
      );
      markers.add(marker);
    });
    state = state.copyWith(listOfMarkers: markers);
  }

  void addUserLocationMarker() {
    List<EachMarkersModel> allMarkers = [];
    allMarkers.addAll(state.listOfMarkers);
    allMarkers.add(
      EachMarkersModel(
        name: "user",
        latitude: state.userPosition!.latitude,
        longitude: state.userPosition!.longitude,
        address: "",
      ),
    );
    state = state.copyWith(listOfMarkers: allMarkers);
  }

  List<PlacemarkMapObject> getPlacemarkObjects(
      {required Function(PlacemarkMapObject, Point)? onTap}) {
    return state.listOfMarkers
        .map(
          (e) => PlacemarkMapObject(
            mapId: MapObjectId("MapObject $e"),
            point: Point(
              latitude: e.latitude,
              longitude: e.longitude,
            ),
            consumeTapEvents: true,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  e.name == "user"
                      ? "assets/images/user_marker.png"
                      : "assets/images/map_icon.png",
                ),
                scale: e.name == "user" ? 2.5.r : 4.r,
              ),
            ),
            opacity: 1,
            onTap: onTap,
          ),
        )
        .toList();
  }

  void changeCameraPosition(
    YandexMapController controller,
    double lat,
    double lon,
  ) {
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: Point(latitude: lat, longitude: lon), zoom: 15),
      ),
      animation: MapAnimation(duration: 1),
    );
  }

  Future<void> getGymsList(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getGymsList();
      response.when(
        success: (data) {
          final gymsMapFromServer = data["object"] as Map<String, dynamic>;
          // 1) создаем лист чтобы потом добавить объекты к нему
          final activities = <GymData>[];
          gymsMapFromServer.forEach((category, gymList) {
            // 2) мапим данные с сервера на key and value
            /* 
            здесь gym  равно Map<String, dynamic> вот так напирмер это один из них;
            так как это цикл оно берет каждого из них один за другим
            {
                "id": 1,
                "name": "Фитнес-клуб Mytimefitness",
                "address": "ул. Ильюшина, 14, Санкт-Петербург, 197372",
                "latitude": "60.00485084852601",
                "longitude": " 30.263218872586002"
            }, 
            */
            for (var gym in gymList) {
              final gymData = GymData(
                id: gym['id'],
                name: gym['name'],
                address: gym['address'],
                latitude: double.parse(gym['latitude']),
                longitude: double.parse(gym['longitude']),
              );
              // сортируем чтобы в лист не добавили одинаковые Gymdata
              if (!activities.any((element) => element.id == gymData.id)) {
                activities.add(gymData);
              }
            }
          });

          state = state.copyWith(listOfActivities: activities);
        },
        failure: (error, statusCode) {
          print("getGymsList notifier failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  Future<void> setMarkerAsOpened(double lat, double lon) async {
    state.listOfMarkers.forEach((element) {
      if (element.latitude == lat && element.longitude == lon) {
        state = state.copyWith(activeMarker: element);
      }
    });
  }

  void showPopUpOnMap(BuildContext context) {
    final overlay = Overlay.of(context);
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 50.w,
          right: 50.w,
          bottom: 30.h,
          child: PopUpMap(
            name: state.activeMarker!.name,
            address: state.activeMarker?.address ?? "??",
          ),
        );
      },
    );
    overlay.insert(entry!);
  }

  void removePopUp() {
    if (entry!.mounted) {
      entry?.remove();
    }
  }
}
