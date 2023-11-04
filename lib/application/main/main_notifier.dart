import 'package:activity/application/main/main_state.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
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
          print("getAdvantages notifier success");
          print("getAdvantages data $data");
          state = state.copyWith(advantages: data);
        },
        failure: (error, statusCode) {
          print("getAdvantages notifier failure");
        },
      );
    } else {
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
          print("getSubscribtions notifier success");
          print(" getSubscribtions data $data");
          state = state.copyWith(subscribtions: data);
        },
        failure: (error, statusCode) {
          print("getSubscribtions notifier failure");
        },
      );
    } else {
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
          print("getComments notifier success");
          print(" getComments data $data");
          state = state.copyWith(comments: data);
        },
        failure: (error, statusCode) {
          print("getComments notifier failure");
        },
      );
    } else {
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
          print("getGymsList notifier success");
          print(" getGymsList data ${data}");
          state = state.copyWith(gymsWithActivities: data["object"]);
        },
        failure: (error, statusCode) {
          print("getGymsList notifier failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }
}
