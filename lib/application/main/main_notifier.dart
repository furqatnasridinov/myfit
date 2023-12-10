import 'package:activity/application/main/main_state.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/models/data/activity_near_client.dart';
import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier(this._mainRepositoryInterface) : super(const MainState());
  final MainRepositoryInterface _mainRepositoryInterface;

  Future<void> getAdvantages(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getAdvantages();
      response.when(
        success: (data) {
          state = state.copyWith(advantages: data);
        },
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  Future<void> getSubscribtions(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getSubscribtions();
      response.when(
        success: (data) {
          state = state.copyWith(subscribtions: data);
        },
        failure: (error, statusCode) {
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  Future<void> getComments(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getComments();
      response.when(
        success: (data) {
          state = state.copyWith(comments: data);
        },
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  void setStep(int index) {
    state = state.copyWith(activeStepState: index);
  }

  void stopAdvantagesAutoPlayMode() {
    state = state.copyWith(advantagesAutoPlayMode: false);
  }

  void commenSetStep(int index) {
    state = state.copyWith(commentActiveStepper: index);
  }

  void stopCommentsAutoPlayMode() {
    state = state.copyWith(commentsAutoPlayMode: false);
  }

  Future<void> getGymsList(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _mainRepositoryInterface.getGymsList();
      response.when(
        success: (data) {
          List<ActivityNearClient> listcha = [];
          Map<String, dynamic> mapData = data["object"];
          mapData.forEach((key, value) {
            final data = ActivityNearClient(
              activityName: key,
              gymdata: (value as List<dynamic>)
                  .map((gym) => GymDataMain.fromJson(gym))
                  .toList(),
            );
            listcha.add(data);
          });
          state = state.copyWith(activitiesNearClient: listcha);
        },
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getAllMarkers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    List<EachMarkersModel> markers = [];
    for (var element in state.activitiesNearClient) {
      element.gymdata?.forEach((e) {
        // Use forEach instead of map
        final marker = EachMarkersModel(
          name: element.activityName ?? "?",
          latitude: double.parse(e.latitude!),
          longitude: double.parse(e.longitude!),
          address: e.address ?? "?",
          id: e.id!,
        );
        if (!markers.any((element) => element.id == marker.id)) {
          markers.add(marker);
        }
      });
    }
    state = state.copyWith(listOfMarkers: markers);
  }

  List<PlacemarkMapObject> getPlacemarkObjects() {
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
          ),
        )
        .toList();
  }

  void determineContainerHeight(GlobalKey key) {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final containerHeight = renderBox.size.height;
    state = state.copyWith(commentsContainerHeight: containerHeight);
  }
}
