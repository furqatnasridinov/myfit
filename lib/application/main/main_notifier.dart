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
  }

  Future<void> getSubscribtions(BuildContext context) async {
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
  }

  Future<void> getComments(BuildContext context) async {
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
  }

  void setStep(int index){
    state = state.copyWith(activeStepState: index);
  }
  void stopAdvantagesAutoPlayMode(){
    state = state.copyWith(advantagesAutoPlayMode: false);
  }
}
