// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/map/map_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/main.dart';
import 'package:myfit/infrastructure/models/data/activity_near_client.dart';
import 'package:myfit/infrastructure/models/data/gym_data.dart';
import 'package:myfit/infrastructure/models/data/lessons_found_by_search.dart';
import 'package:myfit/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:myfit/infrastructure/models/request/get_yandex_map_image_request.dart';
import 'package:myfit/infrastructure/models/response/user_schedules_response.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier(this._mainRepositoryInterface) : super(const MapState());
  final MainRepositoryInterface _mainRepositoryInterface;

  Future<void> getUserLocation() async {
     state = state.copyWith(getLocationLoading: true);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setLocationFromSelectedCity();
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        final postion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        state = state.copyWith(
          userPosition: postion,
          getLocationLoading: false,
          locationPermissionDenied: false
          );
      } catch (e) {
        state = state.copyWith(locationServiceIsNotEnabled: true, getLocationLoading: false);
        setLocationFromSelectedCity();
      }
    }
    state = state.copyWith(getLocationLoading: false);
  }

  Future<void> getAllMarkers(BuildContext context, {ActivityNotifier? activityNotifier}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    Set<Marker> markers = Set.from(state.listOfMarkers);
    BitmapDescriptor icon =  await getDefaulIcon();
    final Map<String, BitmapDescriptor> mapOfIcons = await getIcons(state.activitiesWithGymsInsideFromSelectedDiapozone); // {gymId: iconUrl}
    for (var element in state.activitiesWithGymsInsideFromSelectedDiapozone) {
      element.listOfGyms?.forEach((gym) async {
        final marker = Marker(
          markerId: MarkerId(gym.id.toString()),
          position: LatLng(double.parse(gym.latitude!), double.parse(gym.longitude!)),
          icon: mapOfIcons[gym.id.toString()] ?? icon,
          onTap: () {
            activityNotifier?.getActivityTypes(context, false, state.selectedLessonTypeFromMap, gymId: gym.id ?? 0);
            setSelectedGym(
              name: gym.name,
              latitude: double.parse(gym.latitude!),
              longitude: double.parse(gym.longitude!),
              address: gym.address,
              id: gym.id,
              visitedCount: gym.visitedCount,
              visitPerMonth: gym.visitPerMonth,
            );
            showPopUpOnMap(context, "");
          },
          /* infoWindow: InfoWindow(
              title: gym.name,
              snippet: gym.address,
            ) */
        );
        if (!markers.contains(marker)) {
          markers.add(marker);
        }
      });
    }
    state = state.copyWith(listOfMarkers: markers);
  }

  Future<Map<String, BitmapDescriptor>> getIcons(List<LessonTypeWithGymsInside> list) async{
    Map<String, BitmapDescriptor> mapOfIcons = {};
    for (var element in list) {
      for (var gym in element.listOfGyms!) {
        if (!mapOfIcons.containsKey(gym.id.toString())) {
          if (gym.logoUrl == null || gym.logoUrl!.isEmpty) {
            mapOfIcons[gym.id.toString()] = await getDefaulIcon();
          }else{
            final String compressedLogo = getLinkToCompressedPhoto(gym.logoUrl!);
            mapOfIcons[gym.id.toString()] = await getMarkerIconFromNetwork("${AppConstants.baseUrl}/image/$compressedLogo");
          }
        }
      }
    }
    return mapOfIcons;
  }

  Future<BitmapDescriptor> getDefaulIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1.w, 1.h)),
      "assets/images/map_icon_new.png");
  }

  Future<void> addUserLocationMarker({String avatar = ""}) async {
    if (avatar.isEmpty) {
      avatar = LocalStorage.getAvatar();
    }
    Set<Marker> allMarkers = {};
    allMarkers.addAll(state.listOfMarkers);
    
    BitmapDescriptor icon = avatar.isEmpty ? await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1.w, 1.h)),
      "assets/images/map_icon_new.png",
    ) : await getMarkerIconFromNetwork("${AppConstants.baseUrl}image/$avatar");
    allMarkers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: LatLng(
          state.userPosition!.latitude,
          state.userPosition!.longitude,
        ),
        icon: icon,
      ),
    );
    state = state.copyWith(listOfMarkers: allMarkers);
  }

  Future<void> setUserPosition({String avatar = ""}) async {
    state = state.copyWith(isloading: true);
    setFlexesLoading();
    try {
      final postion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      state = state.copyWith(userPosition: postion);
      BitmapDescriptor icon = avatar.isEmpty ? await getDefaulIcon() : await getMarkerIconFromNetwork("${AppConstants.baseUrl}image/$avatar");
      Marker updatedMarker = Marker(
        markerId: const MarkerId("user"),
        position: LatLng(postion.latitude, postion.longitude),
        icon: icon,
      );
      Set<Marker> markersList = Set.from(state.listOfMarkers);
      if (markersList.any((element) => element.markerId.value == "user")) {
        markersList.removeWhere((element) => element.markerId.value == "user");
      }
      markersList.add(updatedMarker);
      // and sort
      final withCalculatedDistances = calculateDistanceOfGyms(state.activitiesWithGymsInsideAll);
      state = state.copyWith(activitiesWithGymsInsideAll: withCalculatedDistances);
      state = state.copyWith(listOfMarkers: markersList);
      state = state.copyWith(locationPermissionDenied: false);
      state = state.copyWith(isloading: false);
      setFlexes();
    } catch (e) {
      state = state.copyWith(locationServiceIsNotEnabled: true);
    }
  }

  Future<void> getRecommendationForVisit(BuildContext context) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response =
          await _mainRepositoryInterface.getRecommendationForVisiting();
      response.when(success: (data) {
        if (data["operationResult"] == "OK") {
          final operationObject = data["object"];
          if (operationObject["lessonType"] != null) {
            debugPrint(operationObject.toString());
            state = state.copyWith(recommendedGyms: operationObject);
          }
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }
/* 
  Future<void> getYandexMapImage(
    BuildContext context,
  ) async {
    final connected = await AppConnectivity().connectivity();
    //await getUserLocation();
    if (connected) {
      //state = state.copyWith(isloading: true);
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
            state = state.copyWith(
              mapScreenShot: data, /* isloading: false */
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          // state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  } */

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

  LatLng getInitialLatLon() {
    if (state.userPosition != null) {
      return LatLng(
          state.userPosition!.latitude, state.userPosition!.longitude);
    } else {
      return LatLng(double.parse(LocalStorage.getSelectedCityLat()),
          double.parse(LocalStorage.getSelectedCityLon()));
    }
  }

  LatLng getInitialLatLonForSmallMap(List<dynamic> gyms) {
    if (gyms.isNotEmpty) {
      return LatLng(double.parse(gyms[0]["latitude"]),
          double.parse(gyms[0]["longitude"]));
    } else {
      return LatLng(double.parse(LocalStorage.getSelectedCityLat()),
          double.parse(LocalStorage.getSelectedCityLon()));
    }
  }

  List<BoxShadow> getShadows() {
    return const [
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
    ];
  }

  Future<void> setShowOnlyKnown(bool value) async {
    state = state.copyWith(showOnlyKnown: value);
  }

  Future<void> setShowRecommended(bool value) async {
    state = state.copyWith(showRecommended: value);
  }

  void setShowGymsOnlyWithMembership(bool value) {
    state = state.copyWith(showGymsOnlyWithMembership: value);
  }

  Future<void> resetFilterMap()async{
    if (state.showOnlyKnown) {
      state = state.copyWith(showOnlyKnown: false);
    }
    if (state.showRecommended) {
      state = state.copyWith(showRecommended: false);
    }
    if (state.showGymsOnlyWithMembership) {
      state = state.copyWith(showGymsOnlyWithMembership: false);
    }
  }

  Future<void> getGymsList(
    BuildContext context,
    List<String> knownActivities,
    Map<String, dynamic> recommended,
    {List<int> gymIds = const []}
  ) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      setFlexes();
      final response = await _mainRepositoryInterface.getGymsList();
      response.when(
        success: (data) {
          final gymsMapFromServer = data["object"] as Map<String, dynamic>;
          final listToCollectActivitiesWithGyms = <LessonTypeWithGymsInside>[];
          if (state.showOnlyKnown && knownActivities.isNotEmpty) {
            for (var element in knownActivities) {
              gymsMapFromServer.forEach((key, value) {
                if (element == key) {
                  final data = LessonTypeWithGymsInside(
                    false,
                    lessontype: key,
                    listOfGyms: (value as List).map((gym) => Gymdata.fromJson(gym)).toList(),
                  );
                  listToCollectActivitiesWithGyms.add(data);
                }
              });
            }
          } else if (state.showRecommended && recommended.isNotEmpty) {
            // logic to show only recommended
            final data = LessonTypeWithGymsInside(
              false,
              lessontype: recommended["lessonType"],
              listOfGyms: (recommended["gyms"] as List).map((gym) => Gymdata.fromJson(gym)).toList(),
            );
            listToCollectActivitiesWithGyms.add(data);
          } else {
            gymsMapFromServer.forEach((key, value) {
              final data = LessonTypeWithGymsInside(
                false,
                lessontype: key,
                listOfGyms: (value as List).map((gym) => Gymdata.fromJson(gym)).toList(),
              );
              if (state.showGymsOnlyWithMembership) {
                if (gymIds.isNotEmpty) {
                  data.listOfGyms?.removeWhere((element) => !gymIds.contains(element.id));
                }else{
                  data.listOfGyms = [];
                }
              }
              listToCollectActivitiesWithGyms.add(data);
            });
          }
          // Создаем временный список для хранения элементов, которые нужно удалить
          final List<LessonTypeWithGymsInside> elementsToRemove = [];
          
          for (var element in listToCollectActivitiesWithGyms) {
            if (element.listOfGyms!.isEmpty) {
              elementsToRemove.add(element);
            }
          }
          
          // Удаляем элементы после завершения итерации
          listToCollectActivitiesWithGyms.removeWhere((element) => elementsToRemove.contains(element));
          // and sort
          final withCalculatedDistances = calculateDistanceOfGyms(listToCollectActivitiesWithGyms);
          state = state.copyWith(activitiesWithGymsInsideAll: withCalculatedDistances);
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
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
    double formattedDistance = double.parse(distanceInKm.toStringAsFixed(1).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
    );
    return formattedDistance; // in kilometer
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isloading: value);
  }

  List<ActivityNearClient> getFilteredActivitiesNearClient(List<ActivityNearClient> list) {
  // Функция для фильтрации списка по заданному максимальному расстоянию
  List<ActivityNearClient> filterList(double maxDistance) {
    List<ActivityNearClient> filteredList = [];
    filteredList.addAll(list);
    for (var element in filteredList) {
      element.gymdata?.forEach((gym) {
        gym.distanceFromClient = calCulateDistanceSrazy(
          state.userPosition?.latitude ?? 0,
          state.userPosition?.longitude ?? 0,
          double.parse(gym.latitude ?? "0"),
          double.parse(gym.longitude ?? "0"),
        );
      });
      element.gymdata?.removeWhere((gym) => (gym.distanceFromClient ?? 0) > maxDistance);
    }
    filteredList.removeWhere((element) => element.gymdata?.isEmpty ?? true);
    return filteredList;
  }

  // Первая фильтрация с максимальным расстоянием 1 км
  List<ActivityNearClient> firstFilterResult = filterList(30.0);
  return firstFilterResult;
}

  void showMapOnly() {
    state = state.copyWith(topFlexValue: 0.065, bottomFlexValue: 0.74);
    state = state.copyWith(showMapOnly: true);
  }

  void reduceMap() {
    //state = state.copyWith(topFlexValue: 0.3, bottomFlexValue: 0.51);
    state = state.copyWith(showMapOnly: false);
  }

  void setFlexesLoading() {
    state = state.copyWith(
       topFlexValue: 0.41,
        bottomFlexValue: 0.4,
    );
  }

  Future<void> setFlexes() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final list = state.activitiesWithGymsInsideFromSelectedDiapozone;
    bool isAnyOpened = list.any((element) => element.isOpened);
    int listOfgymsInside = isAnyOpened
        ? (list.firstWhere((element) => element.isOpened).listOfGyms?.length ?? 0): 0;
    if (state.isloading) {
      setFlexesLoading();
    }

    if (list.isEmpty && !state.isloading) {
      state = state.copyWith(
        topFlexValue: 0.18,
        bottomFlexValue: 0.63,
      );
    }

    if (list.length == 1 && !state.isloading) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.16,
          bottomFlexValue: 0.645,
        );
      } else {
        if (listOfgymsInside == 1) {
          state = state.copyWith(
            topFlexValue: 0.215, // + 0.055
            bottomFlexValue: 0.59, // - 0.055
          );
        }
        if (listOfgymsInside == 2) {
          state = state.copyWith(
            topFlexValue: 0.27,
            bottomFlexValue: 0.535,
          );
        }
        if (listOfgymsInside >= 3) {
          state = state.copyWith(
            topFlexValue: 0.325,
            bottomFlexValue: 0.480,
          );
        }
      }
    }

    if (list.length == 2) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.215,
          bottomFlexValue: 0.590,
        );
      } else {
        if (listOfgymsInside == 1) {
          state = state.copyWith(
            topFlexValue: 0.27,
            bottomFlexValue: 0.535,
          );
        }
        if (listOfgymsInside == 2) {
          state = state.copyWith(
            topFlexValue: 0.325,
            bottomFlexValue: 0.480,
          );
        }
        if (listOfgymsInside >= 3) {
          state = state.copyWith(
            topFlexValue: 0.380,
            bottomFlexValue: 0.425,
          );
        }
      }
    }

    if (list.length == 3) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.270,
          bottomFlexValue: 0.535,
        );
      } else {
        if (listOfgymsInside == 1) {
          state = state.copyWith(
            topFlexValue: 0.325,
            bottomFlexValue: 0.480,
          );
        }
        if (listOfgymsInside == 2) {
          state = state.copyWith(
            topFlexValue: 0.380,
            bottomFlexValue: 0.425,
          );
        }
        if (listOfgymsInside >= 3) {
          state = state.copyWith(
            topFlexValue: 0.435,
            bottomFlexValue: 0.37,
          );
        }
      }
    }

    if (list.length == 4) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.325,
          bottomFlexValue: 0.480,
        );
      } else {
        state = state.copyWith(
          topFlexValue: 0.380,
          bottomFlexValue: 0.425,
        );
      }
    }

    if (list.length > 4 && !state.isloading) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.335,
          bottomFlexValue: 0.47,
        );
      } else {
        state = state.copyWith(
          topFlexValue: 0.39,
          bottomFlexValue: 0.415,
        );
      }
    }

    if ((list.isNotEmpty && list.length <= 2) &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.21,
          bottomFlexValue: 0.6,
        );
      } else {
        state = state.copyWith(
          topFlexValue: 0.24,
          bottomFlexValue: 0.57,
        );
      }
    }

    if ((list.length >= 3 && list.length <= 4) &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.33,
          bottomFlexValue: 0.48,
        );
      } else {
        state = state.copyWith(
          topFlexValue: 0.36,
          bottomFlexValue: 0.45,
        );
      }
    }

    if (list.length >= 5 &&
        (state.locationPermissionDenied || state.locationServiceIsNotEnabled)) {
      if (!isAnyOpened) {
        state = state.copyWith(
          topFlexValue: 0.5,
          bottomFlexValue: 0.31,
        );
      } else {
        state = state.copyWith(
          topFlexValue: 0.53,
          bottomFlexValue: 0.28,
        );
      }
    }
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

  Future<void> setSelectedGym({
    final String? name,
    final double? latitude,
    final double? longitude,
    final String? address,
    final int? id,
    final int? visitedCount,
    final int? visitPerMonth,
  }) async {
    state = state.copyWith(
        selectedGym: Gym(
      address: address,
      id: id,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
      name: name,
      visitedCount: visitedCount,
      visitPerMonth: visitPerMonth,
    ));
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

  void showPopUpOnMap(BuildContext context, String lesson) {
    // remove prvious pop up first
    removePopUp(); // if there is a pop up remove it
    if (!state.isLocationIconHidden) {
      hideLocationIcon();
    }
    state = state.copyWith(isGymsPopupShown: true, selectedLessonTypeFromMap: lesson);
  }

  void setSelectedActivityFromMap(String lesson) {
    state = state.copyWith(selectedLessonTypeFromMap: lesson);
  }

  void removePopUp() {
    if (state.isGymsPopupShown) {
      state = state.copyWith(isGymsPopupShown: false);
    }
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

  Future<void> changeDiapozoneAndGetActivities(double diapozone, BuildContext context) async {
    if (state.selectedDiapozone != diapozone) {
      if (state.showMapOnly) {
      reduceMap();
    }
    try {
      await changeSelectedDiapozone(diapozone);
      closeOpenedActivities();
      await getGetListOfGymsFromDiapozone();
      await setFlexes();
      await getAllMarkers(context);
      await addUserLocationMarker();
      //context.popRoute();
    } catch (error) {
      // Обработка ошибок
    }
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
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void locationButtonFunction(Completer<GoogleMapController> controller, {String avatar = ""}) async {
    if (state.locationPermissionDenied) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
        }
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          setUserPosition(avatar: avatar).then((value) async {
            controller.future.then((controller) async {
              await controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      state.userPosition!.latitude,
                      state.userPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                ),
              );
            });
            //clusterManager?.updateMap();
          });
        }
    }
    if (!state.locationPermissionDenied && state.locationServiceIsNotEnabled) {
      await Geolocator.openLocationSettings();
    }
    if (!state.locationPermissionDenied && !state.locationServiceIsNotEnabled) {
        controller.future.then((controller) async {
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  state.userPosition!.latitude,
                  state.userPosition!.longitude,
                ),
                zoom: 14,
              ),
            ),
          );
        });
        //clusterManager?.updateMap();
    }
  }

  void openSearchBar() {
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBar() {
    state = state.copyWith(isSearchbarOpened: false);
  }

  Future<void> searchForGymAndLesson(BuildContext context,
      {required String searchString}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.searchForGymAndLesson(
        searchString: searchString,
      );
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            final Map<String, dynamic> mapData = data["object"];
            final List<GymData> listToCollectGyms = [];
            final List<LessonFoundBySearch> listToCollectLessons = [];
            final List listOfGymsFromServer = mapData["gymShortDtos"];
            final List listOfLessonsFromServer = mapData["lessonSearchDto"];
            if (listOfGymsFromServer.isNotEmpty) {
              for (var element in listOfGymsFromServer) {
                final data = GymData(
                  id: element["id"],
                  name: element["name"],
                  address: element["address"],
                  distanceFromClient: calCulateDistanceSrazy(
                    state.userPosition!.latitude,
                    state.userPosition!.longitude,
                    double.parse(element['latitude']),
                    double.parse(element['longitude']),
                  ),
                );
                listToCollectGyms.add(data);
              }
            }
            if (listOfLessonsFromServer.isNotEmpty) {
              for (var element in listOfLessonsFromServer) {
                final data = LessonFoundBySearch(
                  id: element["id"],
                  gymId: element["gymId"] ?? 0,
                  title: element["description"],
                  lessonType: element["lessonType"],
                  date: element["date"],
                  distanceFromClient: calCulateDistanceSrazy(
                    state.userPosition!.latitude,
                    state.userPosition!.longitude,
                    double.parse(element['latitude']),
                    double.parse(element['longitude']),
                  ),
                );
                listToCollectLessons.add(data);
              }
            }
            state = state.copyWith(
              gymsFoundBySearch: listToCollectGyms,
              lessonsFoundBySearch: listToCollectLessons,
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  bool isUserLocation(LatLng position) {
    return state.userPosition != null &&
        state.userPosition!.latitude == position.latitude &&
        state.userPosition!.longitude == position.longitude;
  }

   Future<BitmapDescriptor> getClusterBitmap(
      {String? text, int size = 100, bool isMultiple = false, bool isUser = false, String userAvatar = ""}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = AppColors.blueText;
    if (isMultiple) {
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

      if (text != null && text.isNotEmpty) {
        TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
        painter.text = TextSpan(
          text: text,
          style: GoogleFonts.inter(
              fontSize: size / 3,
              color: Colors.white,
              fontWeight: FontWeight.normal),
        );
        painter.layout();
        painter.paint(
          canvas,
          Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
        );
      }
      final img = await pictureRecorder.endRecording().toImage(size, size);
      final data = await img.toByteData(format: ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
    }else{
      final String src = isUser ? "${AppConstants.baseUrl}image/$userAvatar" : 
          "${AppConstants.baseUrl}image/GYMS/35/logo/09_03_2024_14_41_47_103_M.jpg";
      return await getMarkerIconFromNetwork(src);
    }
  }

  Future<BitmapDescriptor> getMarkerIconFromNetwork(
    String imageUrl, {
    int width = 100,
    int height = 100,
    double borderRadius = 50.0,
  }) async {
    try {
      // Создание экземпляра Dio
      var dio = Dio();
      // Загрузка изображения из сети
      final Response<List<int>> response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      // Преобразование ответа в Uint8List
      final Uint8List bytes = Uint8List.fromList(response.data!);
      // Преобразование байтов в ImageProvider
      ui.Image image = await decodeImageFromList(bytes);
      // Создание PictureRecorder для рендеринга измененного изображения
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);

      // Рисование изображения с закругленными углами
      double size = width < height ? width.toDouble() : height.toDouble();
      Rect rect = Rect.fromLTWH(0, 0, size, size);
      // Создание круглой области для обрезки
      Path clipPath = Path()..addOval(rect);
      // Применение обрезки к холсту
      canvas.clipPath(clipPath);
      paintImage(canvas: canvas, image: image, rect: rect, fit: BoxFit.cover);

      // Завершение рендеринга и преобразование в байты
      ui.Image finalImage =
          await recorder.endRecording().toImage(size.toInt(), size.toInt());
      ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List finalBytes = byteData!.buffer.asUint8List();

      // Создание BitmapDescriptor из измененных байтов
      return BitmapDescriptor.fromBytes(finalBytes);
    } catch (e) {
      // В случае ошибки загрузки, использовать стандартную иконку
      return BitmapDescriptor.defaultMarker;
    }
  }

   String getLinkToCompressedPhoto(String fileName) {
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) {
      // Если точка в имени файла не найдена, возвращаем исходное имя
      return fileName;
    }
    String nameWithoutExtension = fileName.substring(0, lastDotIndex);
    String extension = fileName.substring(lastDotIndex);
    return "${nameWithoutExtension}_M$extension";
  }

  // Вспомогательная функция для декодирования изображения
  static Future<ui.Image> decodeImageFromList(Uint8List list) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(list, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
