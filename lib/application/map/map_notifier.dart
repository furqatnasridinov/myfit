import 'package:activity/application/map/map_state.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:activity/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:activity/infrastructure/models/request/get_yandex_map_image_request.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
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
    // state = state.copyWith(isloading: true);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = state.copyWith(locationPermissionDenied: true);
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        final postion = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        state = state.copyWith(userPosition: postion);
        state = state.copyWith(locationPermissionDenied: false);
      } catch (e) {
        state = state.copyWith(locationServiceIsNotEnabled: true);
      }
    }
  }

  Future<void> setUserPosition() async {
    state = state.copyWith(isloading: true);
    await setFlexes();
    try {
      final postion = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      state = state.copyWith(userPosition: postion);
      var markersList = state.listOfMarkers;
      for (var element in markersList) {
        if (element.name == "user") {
          element.latitude = postion.latitude;
          element.longitude = postion.longitude;
        }
      }
      final withCalculatedDistances = // and sort
          calculateDistanceOfGyms(state.activitiesWithGymsInsideAll);
      state =
          state.copyWith(activitiesWithGymsInsideAll: withCalculatedDistances);

      state = state.copyWith(listOfMarkers: markersList);
      state = state.copyWith(locationPermissionDenied: false);
      state = state.copyWith(isloading: false);
      setFlexes();
    } catch (e) {
      state = state.copyWith(locationServiceIsNotEnabled: true);
    }
  }

  Future<void> getYandexMapImage(
    BuildContext context,
  ) async {
    final connected = await AppConnectivity().connectivity();
    //await getUserLocation();
    if (connected) {
      state = state.copyWith(isloading: true);
      final request = state.userPosition != null
          ? GetYandexMapImageRequest(
              latlon:
                  "${state.userPosition?.longitude},${state.userPosition?.latitude}",
              marker:
                  "${state.userPosition?.longitude},${state.userPosition?.latitude},pm2rdm",
              size: "330,150",
              zoom: 11,
              i: "map",
            )
          : GetYandexMapImageRequest(
              latlon:
                  "${LocalStorage.getSelectedCityLon()},${LocalStorage.getSelectedCityLat()}",
              marker:
                  "${LocalStorage.getSelectedCityLon()},${LocalStorage.getSelectedCityLat()},pm2rdm",
              size: "330,150",
              zoom: 12,
              i: "map",
            );
      final response =
          await _mainRepositoryInterface.getYandexMapImage(request: request);
      response.when(
        success: (data) {
          if (data != null) {
            state = state.copyWith(mapScreenShot: data, isloading: false);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getYandexMapImageWithAllMarkers(
    BuildContext context,
    String markers,
  ) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isloading: true);

      final request = state.userPosition != null
          ? GetYandexMapImageRequest(
              latlon:
                  "${state.userPosition?.longitude},${state.userPosition?.latitude}",
              marker:
                  "${state.userPosition?.longitude},${state.userPosition?.latitude},pm2rdm,$markers",
              size: "300,150",
              zoom: 11,
              i: "map",
            )
          : GetYandexMapImageRequest(
              latlon:
                  "${LocalStorage.getSelectedCityLon()},${LocalStorage.getSelectedCityLat()}",
              marker:
                  "${LocalStorage.getSelectedCityLon()},${LocalStorage.getSelectedCityLat()},pm2rdm,$markers",
              size: "300,150",
              zoom: 10,
              i: "map",
            );
      final response =
          await _mainRepositoryInterface.getYandexMapImage(request: request);
      response.when(
        success: (data) {
          if (data != null) {
            state = state.copyWith(mapScreenShot: data);
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
      state = state.copyWith(isloading: false);
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> setLocationFromSelectedCity() async {
    if (state.locationServiceIsNotEnabled || state.locationPermissionDenied) {
      state = state.copyWith(
          userPosition: Position(
        longitude: double.parse(LocalStorage.getSelectedCityLon()),
        latitude: double.parse(LocalStorage.getSelectedCityLat()),
        timestamp: DateTime.now(),
        accuracy: 5,
        altitude: 5,
        altitudeAccuracy: 0.5,
        heading: 0.5,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      ));
    }
  }

  void setLocationServiceAsEnabled() {
    state = state.copyWith(locationServiceIsNotEnabled: false);
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
        animation: const MapAnimation(duration: 1),
      );
    }
  }

  Future<void> getAllMarkers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    List<EachMarkersModel> markers = [];
    for (var element in state.activitiesWithGymsInsideFromSelectedDiapozone) {
      element.listOfGyms?.forEach((gym) {
        final marker = EachMarkersModel(
          name: gym.name ?? "",
          latitude: double.parse(gym.latitude!),
          longitude: double.parse(gym.longitude!),
          address: gym.address ?? "",
          id: gym.id ?? 0,
        );
        markers.add(marker);
      });
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
            mapId: MapObjectId("MapObject ${e.id}"),
            point: Point(
              latitude: e.latitude ?? 0,
              longitude: e.longitude ?? 0,
            ),
            consumeTapEvents: true,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  e.name == "user"
                      ? "assets/images/user_marker.png"
                      : e.id == state.activeMarker?.id
                          ? "assets/images/centered_icon.png"
                          : "assets/images/map_icon_new.png",
                ),
                scale: e.name == "user"
                    ? 1.5.r
                    : e.id == state.activeMarker?.id
                        ? 1.8.r
                        : 0.5.r,
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
        CameraPosition(
          target: Point(latitude: lat, longitude: lon),
          zoom: 15,
        ),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }

  Future<void> getGymsList(
    BuildContext context,
    bool showOnlyKnown,
  ) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isloading: true);
      await setFlexes();
      final response = await _mainRepositoryInterface.getGymsList();
      response.when(
        success: (data) {
          final gymsMapFromServer = data["object"] as Map<String, dynamic>;
          final listToCollectActivitiesWithGyms = <LessonTypeWithGymsInside>[];
          if (showOnlyKnown) {
            List<String> knownActivities = LocalStorage.getKnownActivities();
            for (var element in knownActivities) {
              gymsMapFromServer.forEach((key, value) {
                if (element == key) {
                  final data = LessonTypeWithGymsInside(
                    false,
                    lessontype: key,
                    listOfGyms: (value as List)
                        .map((gym) => Gymdata.fromJson(gym))
                        .toList(),
                  );
                  listToCollectActivitiesWithGyms.add(data);
                }
              });
            }
          } else {
            gymsMapFromServer.forEach((key, value) {
              final data = LessonTypeWithGymsInside(
                false,
                lessontype: key,
                listOfGyms: (value as List)
                    .map((gym) => Gymdata.fromJson(gym))
                    .toList(),
              );
              listToCollectActivitiesWithGyms.add(data);
            });
          }

          final withCalculatedDistances = // and sort
              calculateDistanceOfGyms(listToCollectActivitiesWithGyms);
          state = state.copyWith(
              activitiesWithGymsInsideAll: withCalculatedDistances);
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
      state = state.copyWith(isloading: false);
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  List<LessonTypeWithGymsInside> calculateDistanceOfGyms(
      List<LessonTypeWithGymsInside> list) {
    final listToCollect = <LessonTypeWithGymsInside>[];
    for (var element in list) {
      element.listOfGyms?.forEach((gym) {
        gym.distanceFromClient = calCulateDistanceSrazy(
          state.userPosition!.latitude,
          state.userPosition!.longitude,
          double.parse(gym.latitude!),
          double.parse(gym.longitude!),
        );
      });
      element.listOfGyms?.sort((a, b) => a.distanceFromClient!
          .compareTo(num.parse(b.distanceFromClient.toString())));
      listToCollect.add(element);
    }
    return listToCollect;
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

  void showMapOnly() {
    state = state.copyWith(topFlex: 0);
    state = state.copyWith(showMapOnly: true);
  }

  void reduceMap() {
    state = state.copyWith(topFlex: 4);
    state = state.copyWith(showMapOnly: false);
  }

  Future<void> setFlexes() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final list = state.activitiesWithGymsInsideFromSelectedDiapozone;
    bool isAnyOpened = list.any((element) => element.isOpened);
    if (state.isloading) {
      state = state.copyWith(
        topFlex: 3,
        bottomFlex: 8,
      );
    }
    if (list.isEmpty) {
      state = state.copyWith(
        topFlex: 3,
        bottomFlex: 10,
      );
    }
    if (list.length == 1 && !state.isloading && !isAnyOpened) {
      state = state.copyWith(
        topFlex: 2,
        bottomFlex: 9,
      );
    }
    if (list.length == 1 && isAnyOpened) {
      state = state.copyWith(
        topFlex: 4,
        bottomFlex: 6,
      );
    }
    if (list.length == 2) {
      state = state.copyWith(
        topFlex: 3,
        bottomFlex: 8,
      );
    }
    if (list.length == 3) {
      state = state.copyWith(
        topFlex: 4,
        bottomFlex: 8,
      );
    }
    if (list.length == 4) {
      state = state.copyWith(
        topFlex: 5,
        bottomFlex: 9,
      );
    }
    if (list.length > 4 && !state.isloading) {
      state = state.copyWith(topFlex: 6, bottomFlex: 8);
    }
    if ((list.isNotEmpty && list.length <= 2) &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      state = state.copyWith(
        topFlex: 4,
        bottomFlex: 6,
      );
    }
    if ((list.length >= 3 && list.length <= 4) &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      state = state.copyWith(
        topFlex: 5,
        bottomFlex: 6,
      );
    }
    if (list.length >= 5 &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      state = state.copyWith(
        topFlex: 7,
        bottomFlex: 5,
      );
    }
  }

  void openGymslist() {
    final list = state.activitiesWithGymsInsideFromSelectedDiapozone;
    if (!state.locationPermissionDenied) {
      if (list.length == 1) {
        state = state.copyWith(topFlex: 3);
        state = state.copyWith(bottomFlex: 8);
      }
      if (list.length == 2) {
        state = state.copyWith(topFlex: 4);
        state = state.copyWith(bottomFlex: 5);
      }
      if (list.length > 2) {
        state = state.copyWith(topFlex: 7);
        state = state.copyWith(bottomFlex: 8);
      }
    }

    /* state = state.copyWith(topFlex: 7);
    state = state.copyWith(bottomFlex: 6); */
  }

  void closeGymslist() {
    setFlexes();
  }

  void closeOpenedActivities() {
    bool isAnyOpened = state.activitiesWithGymsInsideFromSelectedDiapozone
        .any((element) => element.isOpened);
    if (isAnyOpened) {
      for (var element in state.activitiesWithGymsInsideFromSelectedDiapozone) {
        element.isOpened = false;
      }
    }
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

  void hideLocationIcon() {
    state = state.copyWith(isLocationIconHidden: true);
  }

  showLocationButton() {
    state = state.copyWith(isLocationIconHidden: false);
  }

  void showPopUpOnMap(BuildContext context) {
    // remove prvious pop up first
    if (state.activeMarker != null && state.activeMarker?.name != "user") {
      removePopUp(); // if there is a pop up remove it
      if (!state.isLocationIconHidden) {
        hideLocationIcon();
      }
      state = state.copyWith(isGymsPopupShown: true);
    }
  }

  void removePopUp() {
    if (state.isGymsPopupShown) {
      state = state.copyWith(isGymsPopupShown: false);
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

    List<LessonTypeWithGymsInside> listToCollect = [];
    double selectedDiapozone = state.selectedDiapozone;
    final activityWithGyms =
        List<LessonTypeWithGymsInside>.from(state.activitiesWithGymsInsideAll);

    if (selectedDiapozone == 5) {
      listToCollect.addAll(state.activitiesWithGymsInsideAll);
    } else {
      for (var element in activityWithGyms) {
        var listOfGymsCopy = <Gymdata>[];
        element.listOfGyms?.forEach((gymdata) {
          if (gymdata.distanceFromClient! < selectedDiapozone) {
            //var gymdataCopy = gymdata.copyWith();
            listOfGymsCopy.add(gymdata);
          }
        });

        if (listOfGymsCopy.isNotEmpty) {
          var elementCopy = LessonTypeWithGymsInside(
            false,
            lessontype: element.lessontype,
            listOfGyms: listOfGymsCopy,
          );
          listToCollect.add(elementCopy);
        }
      }
    }
    state = state.copyWith(
      activitiesWithGymsInsideFromSelectedDiapozone: listToCollect,
    );
  }

  Future<void> changeDiapozoneAndGetActivities(
      int index, double diapozone, BuildContext context) async {
    if (state.showMapOnly) {
      reduceMap();
    }
    changListOFBoolToTrue(index);
    try {
      await changeSelectedDiapozone(diapozone);
      closeOpenedActivities();
      await getGetListOfGymsFromDiapozone();
      await setFlexes();
      await getAllMarkers();
      await addUserLocationMarker();
      //context.popRoute();
    } catch (error) {
      // Обработка ошибок
    }
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void locationButtonFunction(YandexMapController? mapController) async {
    if (state.locationPermissionDenied) {
      await Geolocator.requestPermission();
    }
    if (!state.locationPermissionDenied && state.locationServiceIsNotEnabled) {
      await Geolocator.openLocationSettings();
    }
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: state.userPosition!.latitude,
            longitude: state.userPosition!.longitude,
          ),
        ),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }

  void openSearchBar() {
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBar() {
    state = state.copyWith(isSearchbarOpened: false);
  }
}
