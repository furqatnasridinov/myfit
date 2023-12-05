import 'package:activity/application/map/map_state.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/presentation/pages/map/widget/pop_up_map.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
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
              latitude: 61.004851,
              longitude: 30.223219,
            ),
          ),
        ),
        animation: const MapAnimation(duration: 3),
      );
    }
  }

  Future<void> getAllMarkers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    List<EachMarkersModel> markers = [];
    for (var element in state.listOfGymsFromSelectedDiapozone) {
      final marker = EachMarkersModel(
        name: element.name ?? "",
        latitude: element.latitude ?? 0,
        longitude: element.longitude ?? 0,
        address: element.address ?? "",
        id: element.id ?? 0,
      );
      markers.add(marker);
    }
    state = state.copyWith(listOfMarkers: markers);
  }

  Future<void> addUserLocationMarker() async {
    List<EachMarkersModel> allMarkers = [];
    allMarkers.addAll(state.listOfMarkers);
    allMarkers.add(
      EachMarkersModel(
        name: "user",
        latitude: state.userPosition!.latitude,
        longitude: state.userPosition!.longitude,
        address: "",
        id: 0,
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
      animation: const MapAnimation(duration: 1),
    );
  }

  Future<void> getGymsList(BuildContext context, int gymId) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getGymsList();
      response.when(
        success: (data) {
          final gymsMapFromServer = data["object"] as Map<String, dynamic>;
          final listToCollectGyms = <GymData>[]; // for adding Gyms
          final listToCollectActivities =
              <String>[]; // for adding activities (keys)
          gymsMapFromServer.forEach((key, value) {
            listToCollectActivities.add(key);
            for (var gym in value) {
              final listToCollectGymsActivities = <String>{};
              listToCollectGymsActivities.add(key);
              final gymData = GymData(
                id: gym['id'],
                name: gym['name'],
                address: gym['address'],
                latitude: double.parse(gym['latitude']),
                longitude: double.parse(gym['longitude']),
                distanceFromClient: calCulateDistanceSrazy(
                  state.userPosition!.latitude,
                  state.userPosition!.longitude,
                  double.parse(gym['latitude']),
                  double.parse(gym['longitude']),
                ),
                activitiesOfGym: listToCollectGymsActivities.toList(),
              );
              // сортируем чтобы в лист не добавилиcь одинаковые Gymdata
              if (!listToCollectGyms
                  .any((element) => element.id == gymData.id)) {
                listToCollectGyms.add(gymData);
              }
            }
          });
          state = state.copyWith(listOfAllGymsFromServer: listToCollectGyms);
          state = state.copyWith(
              listOfAllActivitiesFromServer: listToCollectActivities);
        },
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  double calCulateDistanceSrazy(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    final double result = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    List<String> parts = result.toString().split(".");
    double distanceInMeter = double.parse(parts[0]);
    double distanceInKm = distanceInMeter / 1000;
    double formattedDistance = double.parse(
      distanceInKm
          .toStringAsFixed(2)
          .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
    );
    return formattedDistance; // in kilometer
  }

  Future<void> setMarkerAsOpened(double lat, double lon) async {
    if (state.activeMarker?.latitude == lat ||
        state.activeMarker?.longitude == lon) {
      return;
    }
    for (var element in state.listOfMarkers) {
      if (element.latitude == lat && element.longitude == lon) {
        state = state.copyWith(activeMarker: element);
      }
    }
  }

  Future<void> changeSelectedDiapozone(double diapozone) async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(selectedDiapozone: diapozone);
  }

  void showPopUpOnMap(BuildContext context) {
    // remove prvious pop up first
    removePopUp();
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
            onTap: () {
              entry!.remove();
              context.router.push(
                ActivityRoute(gymId: state.activeMarker!.id),
              );
            },
          ),
        );
      },
    );
    overlay.insert(entry!);
  }

  void removePopUp() {
    if (entry != null && entry!.mounted) {
      entry?.remove();
    }
  }

  void changListOFBoolToTrue(int index) {
    List<bool> bools = List<bool>.from(state.listOfBool);
    bools.fillRange(0, bools.length, false);
    bools[index] = true;
    state = state.copyWith(listOfBool: bools);
  }

  Future<void> getGetListOfGymsFromDiapozone() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List<GymData> list = <GymData>[];

    double selectedDiapozone = state.selectedDiapozone;
    if (selectedDiapozone == 5) {
      list.addAll(state.listOfAllGymsFromServer);
    }
    if (selectedDiapozone != 5) {
      for (var element in state.listOfAllGymsFromServer) {
        if (element.distanceFromClient! < selectedDiapozone) {
          list.add(element);
        }
      }
    }

    state = state.copyWith(listOfGymsFromSelectedDiapozone: list);
  }

  void changeDiapozoneAndPop(
      int index, double diapozone, BuildContext context) {
    changListOFBoolToTrue(index);
    changeSelectedDiapozone(diapozone).then(
      (value) => getGetListOfGymsFromDiapozone().then(
        (value) => getAllMarkers().then(
          (value) => addUserLocationMarker().then(
            (value) => context.popRoute(),
          ),
        ),
      ),
    );
  }

  Future<void> searchGym(BuildContext context, {required String text}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response = await _mainRepositoryInterface.searchGym(text: text);
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            final List listData = data["object"];
            final list = <GymData>[];
            for (var element in listData) {
              final data = GymData(
                id: element["id"],
                name: element["name"],
                latitude: double.parse(element["latitude"]),
                longitude: double.parse(element["longitude"]),
                address: element["address"],
                distanceFromClient: calCulateDistanceSrazy(
                  state.userPosition!.latitude,
                  state.userPosition!.longitude,
                  double.parse(element['latitude']),
                  double.parse(element['longitude']),
                ),
              );
              list.add(data);
            }
            state = state.copyWith(gymFoundBySearching: list);
          }
        },
        failure: (error, statuscode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void openSearchBar() {
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBar() {
    state = state.copyWith(isSearchbarOpened: false);
  }
}
