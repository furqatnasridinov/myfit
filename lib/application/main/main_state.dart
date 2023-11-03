import 'package:activity/infrastructure/models/response/get_advantages_response.dart';
import 'package:activity/infrastructure/models/response/get_comments_response.dart';
import 'package:activity/infrastructure/models/response/get_subscribtions_response.dart';
import 'package:activity/infrastructure/models/response/gym_active_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isloading,
    @Default(null) GetAdvantagesResponse? advantages,
    @Default(null) GetSubscribtionsResponse? subscribtions,
    @Default(null) GetCommentsResponse? comments,
    @Default(1) int activeStepState,
    @Default(true) bool advantagesAutoPlayMode,
    @Default(0) int commentActiveStepper,
    @Default(true) bool commentsAutoPlayMode,
    @Default({})Map<String,dynamic> gymsWithActivities,
  }) = _MainState;
  const MainState._();
}
