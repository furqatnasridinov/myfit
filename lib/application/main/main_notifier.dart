import 'package:myfit/application/main/main_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/main.dart';
import 'package:myfit/infrastructure/models/data/activity_near_client.dart';
import 'package:myfit/infrastructure/models/data/each_markers_models.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
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

  void getUniqueGymLocations() {
    final list = state.activitiesNearClient;
    final Set<String> uniqueLocations = {};
    for (final activity in list) {
      if (activity.gymdata != null) {
        for (final gym in activity.gymdata!) {
          final location = "${gym.longitude},${gym.latitude}";
          uniqueLocations.add(location);
        }
      }
    }
    final latlonString = uniqueLocations.map((e) => "$e,round").join('~');
    state = state.copyWith(latlongsYandexApi: latlonString);
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
          visitedCount: 0,
          visitPerMonth: 0,
        );
        if (!markers.any((element) => element.id == marker.id)) {
          markers.add(marker);
        }
      });
    }
    state = state.copyWith(listOfMarkers: markers);
  }




  void determineContainerHeight(GlobalKey key) {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final containerHeight = renderBox.size.height;
    state = state.copyWith(commentsContainerHeight: containerHeight);
  }
}
